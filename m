Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab2ADXDv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 18:03:51 -0500
Message-ID: <4F04DAD1.5030104@redhat.com>
Date: Wed, 04 Jan 2012 21:03:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PULL] git://git.kernellabs.com/stoth/cx23885-hvr1850.git media-master
 branch
References: <CALzAhNUHJiwv5PmDPZyaxofA+1vBUw7WBV2EoT4VQNZZn--6fg@mail.gmail.com> <4F04D657.7050402@infradead.org>
In-Reply-To: <4F04D657.7050402@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04-01-2012 20:44, Mauro Carvalho Chehab wrote:
> On 04-01-2012 13:28, Steven Toth wrote:
>> Mauro,
>>
>> I've been adding support to the CX23885 and CX25840 drivers for the
>> Hauppauge HVR1850
>> card. These patches enable the use of raw video, audio and/or the mpeg
>> encoder, via all
>> video and audio inputs. Support for the HVR1850 is now in pretty good shape.
>>
>> The card uses the CX23888 PCIe bridge which brings its own complexities and
>> additional code to the CX25840. I've tested these patches against the
>> HVR1700, HVR1800
>> and HVR1850, everything appears to be working correctly.
>>
>> These also fix a small regression in the HVR1800 driver related to the
>> work done during
>> October 2010 on the subdev conversion. Given that nobody has noticed
>> in the last 12
>> months it's not too important.
>>
>> Tree is at git://git.kernellabs.com/stoth/cx23885-hvr1850.git
>> media-master branch.
> 
> Steve,
> 
> Please, always use git request-pull to generate pull requests, otherwise
> patchwork won't catch and I may miss it.
> 
> Thanks,
> Mauro
> 
>>
>> Patch series viewable at:
>>
>> http://git.kernellabs.com/?p=stoth/cx23885-hvr1850.git;a=shortlog;h=refs/heads/media-master

>>     [media] cx25840: Added g_std support to the video decoder driver
>>     [media] cx25840: Hauppauge HVR1850 Analog driver support (patch#4)
>>     [media] cx25840: Add a flag to enable the CX23888 DIF to be enabled or not.
>>     [media] cx23885: Hauppauge HVR1850 Analog driver support (patch#3)
>>     [media] cx23885: Hauppauge HVR1850 Analog driver support (patch#2)
>>     [media] cx23885: Hauppauge HVR1850 Analog driver support (patch#1)
>>     [media] cx23885: Bugfix /sys/class/video4linux/videoX/name truncation

Not applied the above patches, due to a compilation breakage on the next
patch that are before them.

>>     [media] cx23885: Control cleanup on the MPEG Encoder

There's something wrong on this patch. It breaks compilation:

drivers/media/video/cx23885/cx23885-417.c: In function ‘vidioc_s_std’:
drivers/media/video/cx23885/cx23885-417.c:1240:2: error: implicit declaration of function ‘cx23885_set_tvnorm’ [-Werror=implicit-function-declaration]
drivers/media/video/cx23885/cx23885-417.c: In function ‘vidioc_enum_input’:
drivers/media/video/cx23885/cx23885-417.c:1251:2: error: implicit declaration of function ‘cx23885_enum_input’ [-Werror=implicit-function-declaration]
drivers/media/video/cx23885/cx23885-417.c: In function ‘vidioc_g_input’:
drivers/media/video/cx23885/cx23885-417.c:1256:2: error: implicit declaration of function ‘cx23885_get_input’ [-Werror=implicit-function-declaration]
drivers/media/video/cx23885/cx23885-417.c: In function ‘vidioc_s_input’:
drivers/media/video/cx23885/cx23885-417.c:1261:2: error: implicit declaration of function ‘cx23885_set_input’ [-Werror=implicit-function-declaration]
drivers/media/video/cx23885/cx23885-417.c: In function ‘vidioc_s_frequency’:
drivers/media/video/cx23885/cx23885-417.c:1316:2: error: implicit declaration of function ‘cx23885_set_frequency’ [-Werror=implicit-function-declaration]
drivers/media/video/cx23885/cx23885-417.c: In function ‘vidioc_g_ctrl’:
drivers/media/video/cx23885/cx23885-417.c:1324:2: error: implicit declaration of function ‘cx23885_get_control’ [-Werror=implicit-function-declaration]
drivers/media/video/cx23885/cx23885-417.c: In function ‘vidioc_s_ctrl’:
drivers/media/video/cx23885/cx23885-417.c:1332:2: error: implicit declaration of function ‘cx23885_set_control’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Please fix it. No patch should break compilation, or it would affect
"git bisect" handling with is bad not only for media developers, but for
everybody else working with Kernel development.

>>     [media] cx23885: Configure the MPEG encoder early to avoid jerky video

This one also breaks compilation: 

drivers/media/video/cx23885/cx23885-417.c:1351:2: error: too few arguments to function ‘cx23885_initialize_codec’

In this specific case, the fix is trivial, so, I've applied it, and added a
reviewer note about the breakage fix.

>>     [media] cx23885: Ensure the MPEG encoder height is configured from the norm
>>     [media] cx23885: Cleanup MPEG encoder GPIO handling
>>     [media] cx25840 / cx23885: Fixing audio/volume regression

Those were also applied.

Regards,
Mauro
