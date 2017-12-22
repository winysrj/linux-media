Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:44282 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752207AbdLVXRL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 18:17:11 -0500
Subject: Re: [PATCH v4 6/6] [media] cxusb: add analog mode support for Medion
 MD95700
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org,
        Philippe Ombredanne <pombredanne@nexb.com>
References: <cover.1513536096.git.mail@maciej.szmigiero.name>
 <8b06f30b-bd92-6454-c810-c2774fd8818b@maciej.szmigiero.name>
 <20171219105329.3d6b2fb4@vento.lan>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <4edb4d39-81af-1bdc-bcc2-e3d68bc68374@maciej.szmigiero.name>
Date: Sat, 23 Dec 2017 00:17:07 +0100
MIME-Version: 1.0
In-Reply-To: <20171219105329.3d6b2fb4@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19.12.2017 13:53, Mauro Carvalho Chehab wrote:
> Em Sun, 17 Dec 2017 19:47:25 +0100
> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> escreveu:
> 
>> This patch adds support for analog part of Medion 95700 in the cxusb
>> driver.
>>
>> What works:
>> * Video capture at various sizes with sequential fields,
>> * Input switching (TV Tuner, Composite, S-Video),
>> * TV and radio tuning,
>> * Video standard switching and auto detection,
>> * Radio mode switching (stereo / mono),
>> * Unplugging while capturing,
>> * DVB / analog coexistence,
>> * Raw BT.656 stream support.
>>
>> What does not work yet:
>> * Audio,
>> * VBI,
>> * Picture controls.
> 
> Patches 1 to 5 look OK to me (although checkpatch do a few complains).
> 
> This one, however, require some adjustments.
> 
> I'd like to also have Hans eyes on it, as he's doing a lot more V4L2
> new driver reviews than me nowadays.
> 
(..)
>> +static int cxusb_medion_try_s_fmt_vid_cap(struct file *file,
>> +					  struct v4l2_format *f,
>> +					  bool isset)
>> +{
>> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +	struct v4l2_subdev_format subfmt;
>> +	int ret;
>> +
>> +	if (isset && (cxusb_medion_stream_busy(cxdev) ||
>> +		      vb2_is_busy(&cxdev->videoqueue)))
>> +		return -EBUSY;
>> +
>> +	memset(&subfmt, 0, sizeof(subfmt));
>> +	subfmt.which = isset ? V4L2_SUBDEV_FORMAT_ACTIVE :
>> +		V4L2_SUBDEV_FORMAT_TRY;
>> +	subfmt.format.width = f->fmt.pix.width & ~1;
>> +	subfmt.format.height = f->fmt.pix.height & ~1;
>> +	subfmt.format.code = MEDIA_BUS_FMT_FIXED;
>> +	subfmt.format.field = V4L2_FIELD_SEQ_TB;
>> +	subfmt.format.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +
>> +	ret = v4l2_subdev_call(cxdev->cx25840, pad, set_fmt, NULL, &subfmt);
>> +	if (ret != 0) {
>> +		if (ret != -ERANGE)
>> +			return ret;
>> +
>> +		/* try some common formats */
>> +		subfmt.format.width = 720;
>> +		subfmt.format.height = 576;
>> +		ret = v4l2_subdev_call(cxdev->cx25840, pad, set_fmt, NULL,
>> +				       &subfmt);
>> +		if (ret != 0) {
>> +			if (ret != -ERANGE)
>> +				return ret;
>> +
>> +			subfmt.format.width = 640;
>> +			subfmt.format.height = 480;
>> +			ret = v4l2_subdev_call(cxdev->cx25840, pad, set_fmt,
>> +					       NULL, &subfmt);
>> +			if (ret != 0)
>> +				return ret;
>> +		}
>> +	}
> 
> That looks weird... Why are you trying two different formats here,
> instead of just using the width/height that userspace passes?
> 
V4L2 docs say that VIDIOC_{S,TRY}_FMT ioctls "should not return an error
code unless the type field is invalid", that is, they should not return
an error for invalid or unsupported image widths or heights.
They should instead return something sensible for these image parameters.

However, cx25840 driver set_fmt callback simply returns -ERANGE if it
does not like the provided width or height.
In this case the code above simply tries first the bigger PAL capture
resolution then the smaller NTSC one.
Which one will be accepted by the cx25840 depends on the currently set
broadcast standard and parameters of the last signal that was received,
at least one of these resolutions seem to work even without any
signal being received since the chip was powered up.

This way the API guarantees should be kept by the driver.

(All other your comments were implemented in a respin).

> 
> Thanks,
> Mauro
> 

Thanks,
Maciej
