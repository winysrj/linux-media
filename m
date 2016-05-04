Return-path: <linux-media-owner@vger.kernel.org>
Received: from 18.mo5.mail-out.ovh.net ([178.33.45.10]:60937 "EHLO
	18.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbcEDPya (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 11:54:30 -0400
Received: from player788.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo5.mail-out.ovh.net (Postfix) with ESMTP id 5F9611004221
	for <linux-media@vger.kernel.org>; Wed,  4 May 2016 15:27:29 +0200 (CEST)
Subject: Re: [PATCH v2] Add GS driver (SPI video serializer family)
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <dfff4181-edd7-b855-cdad-9d35fe940704@nexvision.fr>
 <5729DFE0.6080600@xs4all.nl>
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Message-ID: <40ac6b0a-2234-0a29-2932-12f922fa2609@nexvision.fr>
Date: Wed, 4 May 2016 15:27:27 +0200
MIME-Version: 1.0
In-Reply-To: <5729DFE0.6080600@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 04/05/2016 à 13:41, Hans Verkuil a écrit :
> Hi Charles-Antoine,

Hi,

> On 04/28/2016 04:10 PM, Charles-Antoine Couret wrote:
>> But this component family support CEA standards and other
>> (SMPTE XXXM in fact). V4L2 seems oriented to manage CEA or
>> VGA formats. So, I used timings structure with CEA values, but I
>> fill timings fields manually for other standards. I don't know if it
>> is the right method or if another interface should be more interesting.
> 
> As long as the timings are part of a standard, then just add them to
> the v4l2-dv-timings.h header. Since these timings aren't part of the CEA-861
> standard or the DMT VESA standard, just add a new SMPTE standard flag.

Ok, but I should have difficulties to define correctly these standards.
I worked on video stream in SMPTE-125M and I don't know if other SMPTE standards are based on the same characteristics.
In addition to this, those standards are not public.

For the SMPTE-125M, I have these information:
* Pixelclock : 27 MHz (I set 13.5MHz to have 60 FPS because its a interlaced signal, I don't know if it's correct)
* The organization of lines :
Line 1 to 9 : blanking
Line 10 to 19 : options (blanking in my case for example)
Line 20 to 264 : field 1
Line 266 to 272 : blanking
Line 273 to 282 : options
Line 283 to 525 : field 2

The time of blanking are not regular: 19 then 18 lines, how translate that in dv_timings?
The size of fields is different too.

The Field signal is changed in 266 line.
* Complete format size (with blanking) ; 858x525
* Image size : 720x487

Organization of horizontal sync :
Pixel 0 to 719 : active pixels
Pixel 720 to 857 : blanking (but the firsts 16 pixels are the front porch, but after, no info for sync or back porch timings)

Polarity: V-, H+

And, I don't have info for other standards and the GS1662 don't need that too.
I should create SMPTE format but only for the 125M? And the driver shouldn't use / consider other SMPTE formats without a right definition?

>> This patch was tested with GS1662:
>> http://www.c-dis.net/media/871/GS1662_Datasheet.pdf
> 
> A pointer to this datasheet should be in a comment in the source code.

Ok. The commit message should keep the link too?


>>  drivers/media/spi/gsxxxx.c | 482 +++++++++++++++++++++++++++++++++++++++++++++
> 
> I would just call it gs1662. That's all you've tested with, after all.
> 
> It is very common that drivers named after the first supported model also
> support similar models.

Ok, thanks.

>> +struct gsxxxx {
> 
> The gsxxxx prefix is rather ugly. I'd just use gs_ instead.

Yes, I agree with you.

>> +static void custom_to_timings(const struct gsxxxx_reg_fmt_custom *custom,
>> +			      struct v4l2_dv_timings *timings)
>> +{
>> +	timings->type = V4L2_DV_BT_656_1120;
>> +	timings->bt.width = custom->width;
>> +	timings->bt.height = custom->height;
>> +	timings->bt.pixelclock = custom->pixelclock;
>> +	timings->bt.interlaced = custom->interlaced;
>> +	timings->bt.polarities = 0;
>> +	timings->bt.hbackporch = 0;
>> +	timings->bt.hsync = 0;
>> +	timings->bt.hfrontporch = 0;
>> +	timings->bt.vbackporch = 0;
>> +	timings->bt.vsync = 0;
>> +	timings->bt.vfrontporch = 0;
>> +	timings->bt.il_vbackporch = 0;
>> +	timings->bt.il_vsync = 0;
>> +	timings->bt.il_vfrontporch = 0;
> 
> You still need to set the total blanking sizes, right?
> 
> For now assign that to the [hv]frontporch, leaving the sync and
> backporch fields 0. I need to make some rules how this is handled when
> the standard doesn't separate the blanking into back/frontporch and syncs.

Seeing my first comment.
I could precise some info (for 125M) but not for all of them.
And the GS1662 don't care about those information: we can't configure timings, only ask a specific format.

And, how manage the case of there are two different timings for vertical blanking for one image in the standard?

>> +	timings->bt.standards = 0;
> 
> So we need to define a proper standard for this.

Yes.
 
> So, regarding the reset, s_dv_timings and query_dv_timings: it's not clear
> what is happening here. The usual way things work is that the timings that
> s/g_dv_timings set and get are indepedent of the timings that are detected
> (query_dv_timings). The reason is that the explicitly set timings relate to
> the buffers that the DMA engine needs to store the frames. Receivers that
> spontaneously switch when new timings are detected can be very dangerous
> depending on the details of the DMA engine (think buffer overruns when you
> go from e.g. 720p to 1080p).

It's the case here.
s/g_dv_timings are independent of query_detect_timings which reads internal registers to
define the stream detected by the component.

The reset function are an error, I think.
By default the GS1662 is in auto-mode: it detects the input stream to create the serialized output stream.
The reset was to return in auto-mode selection, but this function should be to reset the component and not the mode.

I don't have idea to define properly the auto-mode, for userspace and the driver.
It's a useful information and I think, the userspace should force this mode. Define a specific timings for that?

> So typically when you set the timings the device is fixed to those timings,
> even if it receives something different. If the device supports an interrupt,
> then it is good practice to hook into that interrupt and, when it detects
> that the timings changed, the device sends a V4L2_EVENT_SOURCE_CHANGE event.
> 
> Userspace will then typically stop streaming, query the new timings, setup
> the new buffers and restart streaming.

GS1662 don't have interruption line to do that.

> Some devices cannot query the new timings unless they are in autodetect mode.
> The correct implementation for that is that query_dv_timings returns EBUSY
> while the device is streaming (you hook into the s_stream core op to know that),
> otherwise it configures itself to autodetect mode and sees what is detected.
> 
> It is not really clear to me from the datasheet how this device behaves. But
> having to use the reset op is almost certainly wrong.

I don't understand.
The GS1662 has a status to say the input format detected. Useful in auto-detect mode,
less in other cases. But, it needs a input, why send EBUSY error when the device streams?

>> +static int gsxxxx_enum_dv_timings(struct v4l2_subdev *sd,
>> +				  struct v4l2_enum_dv_timings *timings)
>> +{
>> +	if (timings->index >= ARRAY_SIZE(reg_fmt))
>> +		return -EINVAL;
>> +
>> +	timings->timings = reg_fmt[timings->index].format;
> 
> Hmm, there are duplicate format entries in the reg_fmt array. It would be
> good if you can explain the differences between otherwise identical entries.
> I would have to think about how those differences should be represented.

Yes, I didn't paid attention to that. Thanks.
The format difference:
* Sometimes it's generic/specific format (like in SMPTE-125M: 487 lines vs (858x525) 720x487)
without information about the "generic" meaning.
* In other case it's normal vs "EM" standards (difference between HANC and active pixels size per line).

But the "EM" version is not CEA-861 compliant for me, but close to.
Maybe this info should be important for others and I should add details.

>> +static void __exit gsxxxx_exit(void)
>> +{
>> +	spi_unregister_driver(&gsxxxx_driver);
>> +}
>> +
>> +module_init(gsxxxx_init);
>> +module_exit(gsxxxx_exit);
> 
> Use module_spi_driver here.

Yes, thanks!
 
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>");
>> +MODULE_DESCRIPTION("GSXXXX SPI driver to read and write its registers");
> 
> That's rather vague. How about: "Gennum GS1662 HD/SD-SDI Serializer driver".

Ok.

Thank you for all your comments. I will improve with a v3 patch but I need some answers to do that correctly.
I'm sorry for some mistakes, I use this driver in precise use case and I didn't take account all others use cases to design that correctly.
And, like I'm beginner, it's difficult to me to decide how implement common interfaces (for SMPTE timings for example) which could be used by other drivers.

Regards.
Charles-Antoine Couret
