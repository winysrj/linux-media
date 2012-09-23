Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37878 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2IWSjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 14:39:33 -0400
Received: by lbbgj3 with SMTP id gj3so5827789lbb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 11:39:32 -0700 (PDT)
Message-ID: <505F5760.2030602@gmail.com>
Date: Sun, 23 Sep 2012 20:39:28 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com> <20120915145834.0b763f73@redhat.com> <5054C521.1090200@gmail.com> <20120915192530.74aedaa6@redhat.com> <50559241.6070408@gmail.com> <505844A0.30001@redhat.com> <5059C242.3010902@gmail.com> <5059F68F.4050009@redhat.com> <505A1C16.40507@gmail.com> <CAGncdOae+VoAAUWz3x84zUA-TCMeMmNONf_ktNFd1p7c-o5H_A@mail.gmail.com> <505C7E64.4040507@redhat.com> <8ed8c988-fa8c-41fc-9f33-cccdceb1b232@email.android.com> <505EF455.9080604@redhat.com> <505F4CBC.1000201@gmail.com>
In-Reply-To: <505F4CBC.1000201@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-23 19:54, Anders Thomson wrote:
> >  diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
> >  index bc08f1d..98b482e 100644
> >  --- a/drivers/media/pci/saa7134/saa7134-cards.c
> >  +++ b/drivers/media/pci/saa7134/saa7134-cards.c
> >  @@ -3288,13 +3288,13 @@ struct saa7134_board saa7134_boards[] = {
> >    		.name           = "Pinnacle PCTV 310i",
> >    		.audio_clock    = 0x00187de7,
> >    		.tuner_type     = TUNER_PHILIPS_TDA8290,
> >    		.radio_type     = UNSET,
> >    		.tuner_addr     = ADDR_UNSET,
> >    		.radio_addr     = ADDR_UNSET,
> >  -		.tuner_config   = 1,
> >  +		.tuner_config   = 0,
> >    		.mpeg           = SAA7134_MPEG_DVB,
> >    		.gpiomask       = 0x000200000,
> >    		.inputs         = {{
> >    			.name = name_tv,
> >    			.vmux = 4,
> >    			.amux = TV,
> >
> >
> >  Please test if the above patch fixes the issue you're suffering[1]. If so, then
> >  we'll need to add a modprobe parameter to allow disabling LNA for saa7134 devices
> >  with LNA.
> >
> >  [1] Note: the above is not the fix, as some users of this board may be using the
> >  original antenna, and changing tuner_config will break things for them; the right
> >  fix is likely to allow controlling the LNA via userspace.
> Tried that patch on 3.5.3. No improvement, unfortunately.
I have to retract that. It turns out that there is some strange interaction
between the cabletv box and the card. When I rebooted into 'my' patch
I still got the noisy signal. I then power cycled the cabletv box, and 
voila,
I got a good signal on my own patch. Wondering what I had actually tested
with your patch, I tested it again, and indeed it works!

So, 1) you're on to something, that's for sure, and 2) there is 
_something_ in
the cabletv box which can make all this fall into a bad state too.

Cheers,
/Anders




