Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910Ab0BDMTp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 07:19:45 -0500
Message-ID: <4B6ABB54.80001@redhat.com>
Date: Thu, 04 Feb 2010 10:19:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de
Subject: Re: [PATCH v2 00/10] add linux driver for chip TLG2300
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com> <4B6817E6.4070709@redhat.com> <4B69159D.2040606@gmail.com> <4B6925EB.7000601@redhat.com> <4B693681.2030402@gmail.com> <4B693AD6.3030005@redhat.com> <4B6A8E02.3090905@gmail.com>
In-Reply-To: <4B6A8E02.3090905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huang Shijie wrote:
> 
>> No, I don't meant that.
>>
>> The differences of FM radio standards are basically the preemphasis
>> and the
>> frequency ranges.
>>
>> For frequency ranges, V4L2_TUNER_RADIO allows specifying the
>> maximum/minimum values.
>>
>> For preemphasis, you should implement V4L2_CID_TUNE_PREEMPHASIS ctrl.
>> This
>> CTRL has 3 states:
>>
>>          static const char *tune_preemphasis[] = {
>>                  "No preemphasis",
>>                  "50 useconds",
>>                  "75 useconds",
>>                  NULL,
>>          };
>>
>> At v4l2-common.c, there are some functions that helps to implement it
>> at the driver, like:
>>     v4l2_ctrl_get_menu, v4l2_ctrl_get_name and v4l2_ctrl_query_fill.
>>    
> I meet a problem now. :(
> 
> Even I add the ctrl to the tlg2300 driver, there is no application to
> test it :
> 
> [1] The Mplayer do not check the ctrl except the "vulume " or "mute".


Unfortunately, userspace applications take some time to follow kernel changes.

Yet, there are a few generic applications for it, both hosted together with
the v4l-dvb mercurial tree: v4l2-ctl and qv4l2. On both applications, the
controls are retrieved dynamically. In particular, v4l2-ctl is a command-line
application. So, you may call it when the device is detected (for example, by
udev) or before starting the application.

This is very useful with dumb applications that doesn't give full control over
the device.

For example, I use it on my environment to pre-adjust my webcam to give a clearer
image, when using on skype, with this script:

	export LD_PRELOAD=/usr/lib64/libv4l/v4l1compat.so
	v4l2-ctl -cexposure=1000
	v4l2-ctl -cwhite_balance=47
	export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
	/usr/bin/skype.real $_

> [2] I do  not know how to use the VLC to listen the radio with ALSA, I
> tried many times, but failed. Does someone know this ?

I've no idea. Never tried vlc for radio here.

> Btw: I will be on my vacation for the following two weeks, I will come
> back to
> work at 20th of this month. I afraid I can not finish the patches to
> remove  the
> country code in the two days(today and tomorrow).

-rc7 is about to be released. So, it is late for 2.6.33 cycle.

I think we'll have -rc8 again, as there were several changes at drm/nouveau/x86 arch. 
I may be wrong though. Assuming that I did a good guess, we'll have +2 weeks for the 
next merge window. Also, as this is a new driver, if we miss the merge window, we may
try to submit it for -rc1 or -rc2.

So, providing that, on your return, you focus on it, I think it would be possible to
have it added for 2.6.34.

-- 

Cheers,
Mauro
