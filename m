Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40970 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbcGKLxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 07:53:08 -0400
Subject: Re: [PATCH v3] Add tw5864 driver
To: Andrey Utkin <andrey_utkin@fastmail.com>
References: <20160709194618.15609-1-andrey_utkin@fastmail.com>
 <cac4c81a-9065-2337-7d34-eea8b8482519@xs4all.nl> <20160711114800.GW5934@zver>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kozlov Sergey <serjk@netup.ru>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <670e4e8b-ea65-e6ed-b313-d1aad80e79fa@xs4all.nl>
Date: Mon, 11 Jul 2016 13:52:55 +0200
MIME-Version: 1.0
In-Reply-To: <20160711114800.GW5934@zver>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2016 01:48 PM, Andrey Utkin wrote:
> Thanks for review Hans!
> 
> On Mon, Jul 11, 2016 at 07:58:38AM +0200, Hans Verkuil wrote:
>>> +" v4l2-ctl --device $dev --set-ctrl=video_gop_size=1; done\n"
>>
>> Replace $dev by /dev/videoX
>>
>> Wouldn't it make more sense to default to this? And show the warning only if
>> P-frames are enabled?
> 
> I believe it's better to leave P-frames on by default. All-I-frames
> stream has huge bitrate. And the pixels artifacts is not very strong,
> it's 0 - 10 bad pixels on picture at same time in our dev environment,
> and probably up to 50 bad pixels max in other environments I know of.
> 
>>> +	dma_sync_single_for_cpu(&dev->pci->dev, cur_frame->vlc.dma_addr,
>>> +				H264_VLC_BUF_SIZE, DMA_FROM_DEVICE);
>>> +	dma_sync_single_for_cpu(&dev->pci->dev, cur_frame->mv.dma_addr,
>>> +				H264_MV_BUF_SIZE, DMA_FROM_DEVICE);
>>
>> This is almost certainly the wrong place. This should probably happen in the
>> tasklet. The tasklet runs after the isr, so by the time the tasklet runs
>> you've already called dma_sync_single_for_device.
> 
> Thanks, moved to tasklet subroutine tw5864_handle_frame().
> 
> I didn't seem to me like dma_sync_single_for_* can take long time or be
> otherwise bad to be done from interrupt context.
> 
>>> +static int tw5864_querycap(struct file *file, void *priv,
>>> +			   struct v4l2_capability *cap)
>>> +{
>>> +	struct tw5864_input *input = video_drvdata(file);
>>> +
>>> +	strcpy(cap->driver, "tw5864");
>>> +	snprintf(cap->card, sizeof(cap->card), "TW5864 Encoder %d",
>>> +		 input->nr);
>>> +	sprintf(cap->bus_info, "PCI:%s", pci_name(input->root->pci));
>>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
>>> +		V4L2_CAP_STREAMING;
>>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>
>> This line can be dropped, the core will fill in the capabilities field for you.
> 
> No, removing this line causes v4l2-compliance failures and also ffmpeg fails to
> play the device.

My fault. I mixed things up. The struct video_device has a new device_caps field. That
should be filled in with the caps and then in the function above you can drop both
the device_caps and capabitlities assignments.

Sorry about that.

Regards,

	Hans

> 
> Required ioctls:
>                 fail: v4l2-compliance.cpp(550): dcaps & ~caps
>         test VIDIOC_QUERYCAP: FAIL
> 
> Allow for multiple opens:
>         test second video open: OK
>                 fail: v4l2-compliance.cpp(550): dcaps & ~caps
>         test VIDIOC_QUERYCAP: FAIL
> 
