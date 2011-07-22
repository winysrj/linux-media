Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54898 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1GVMts (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 08:49:48 -0400
Message-ID: <4E2971D4.1060109@infradead.org>
Date: Fri, 22 Jul 2011 09:49:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru>
In-Reply-To: <4E296F6C.9080107@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-07-2011 09:39, Stas Sergeev escreveu:
> 22.07.2011 16:28, Mauro Carvalho Chehab wrote:
>> In this specific case, applications like mplayer,
>> using the alsa parameters for streaming will stop work, as mplayer
>> won't touch at the mixer or at the V4L mute control. So,
>> it will have the same practical effect of a kernel bug at the
>> audio part of the driver.
> Let me quote you again:
> ---
> Some applications like mplayer don't use V4L2_CID_AUDIO_MUTE to unmute a
> video device. They assume the current behavior that starting video also
> unmutes audio.

Let me rephase it:
Some applications like mplayer don't use V4L2_CID_AUDIO_MUTE to unmute a
video device. They assume the current behavior that starting audio on a
video board also unmutes audio.

> ---
> Could you please explain how my patch breaks
> "starting video also unmutes audio"? I haven't touched
> anything related to "starting video", so, if starting video
> used to unmute audio, it will keep it that way.
> Can you tell me how exactly I can reproduce that breakage?

