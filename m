Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1GWB2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 21:28:44 -0400
Message-ID: <4E2A23C7.3040209@infradead.org>
Date: Fri, 22 Jul 2011 22:28:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru>
In-Reply-To: <4E29E02A.1020402@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-07-2011 17:40, Stas Sergeev escreveu:
> 22.07.2011 17:03, Mauro Carvalho Chehab wrote:
>> Here, I add the following line at my .mplayer/config:
>>
>> tv        = "driver=v4l2:device=/dev/video0:norm=PAL-M:chanlist=us-bcast:alsa=1:adevice=hw.1:audiorate=32000:immediatemode=0:amode=1"
> Thanks for starting to answer what I was asking for over a week. :)
> If this is the case (not verified yet), there may be the simple
> automute logic that will fix that in an absense of an auto-unmute
> in alsa.
> Initially, the driver may be put in an auto-mute state.
> It is mute until the tuner is tuned: after the tuner is tuned,
> the audio gets immediately automatically unmuted.
> If the app does not want this to happen, it may use
> the V4L2_CID_AUDIO_MUTE before tuning, to put the device
> in a permanent-mute state.
> So, in short, I suggest to bind the auto-unmute to the
> tuner tune, rather than to the capture start. And that
> should be a separate, third mute state, automute. If the
> app explicitly wants the mute or unmute, this automute
> logic disables.
> Do you know any app that will regress even with that?

Mplayer was just one example of an application that I know
it doesn't call V4L2_CID_AUDIO_MUTE to unmute. I didn't 
check for other applications and scripts that may break
with such change.

Your approach of moving it to VIDIOC_S_FREQUENCY (if I 
understood well) won't work, as, every time someone would 
change the channel, it will be unmuted, causing troubles
on applications like "scantv" (part of xawtv).

You can't associate such logic to any ioctl, due to the
same reasons. Also, associating with V4L open also will
cause side effects, as udev opens all V4L devices when
the device is detected.

You should also remind that it is possible to use a separate
application (like v4l2-ctl) while a device is opened
by other applications, and even to not have the device
opened while streaming (radio applications allow that).

Mauro.
