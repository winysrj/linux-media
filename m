Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-6.eutelia.it ([62.94.10.166]:35589 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757062AbZJCTIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 15:08:48 -0400
Message-ID: <4AC79B4A.5030809@email.it>
Date: Sat, 03 Oct 2009 20:43:22 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: Dainius Ridzevicius <ridzevicius@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: New device: Dikom DK-300 (maybe Kworld 323U rebranded)
References: <9577d4e00908130614q1d8c2c60kdcf74d324c897572@mail.gmail.com>	 <4A84138A.3050909@email.it> <9577d4e00908130934k77fb2b2ag124da076f448b1be@mail.gmail.com>
In-Reply-To: <9577d4e00908130934k77fb2b2ag124da076f448b1be@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dainius,
I'm using the modified driver as you suggested but I can't see analog tv
  because the system has a kernel loop when I try to tune the analog
channels.
Does your card have an analog tuner too?
Do you have a v4l branch or do you know if someone has included your
modification in thr main tree?
Thank you,
Xwang

Dainius Ridzevicius ha scritto:
> Hi,
> 
> replace files in /v4l-dvb/linux/drivers/media/video/em28xx
> with attached ones and make all v4l-dvb.
> make && make install. Reboot to clean old modules.
> 
> DVB-T on kwordl 323ur is working, watching TV for an hour now.
> 
> regards,
> 
> 
> On Thu, Aug 13, 2009 at 4:22 PM, <xwang1976@email.it 
> <mailto:xwang1976@email.it>> wrote:
> 
>     Yes,
>     I'm still interested.
>     I suppose it is the same device.
>     In the next days I hope I will be able to take an usbsnoop of the
>     device under windows xp.
>     Meantime, I would like to test your drive.
>     Regards,
>     Xwang
> 
>     Dainius Ridzevicius ha scritto:
> 
>         Hello,
> 
>         I have got Kworld 323UR hybrid tuner and managed to get dvb-t
>         lock today, will do some more testing later, but I can email or
>         post you a link for v4l-dvb sources changed by me (from todays
>         mercurial) if You are still interested.
> 
>         Regards,
>         Dainius
> 
> 
>         -- 
>         -----------------------------------------
> 
> 
> 
> 
> -- 
> -----------------------------------------

