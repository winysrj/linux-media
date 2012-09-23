Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51855 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2IWRyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 13:54:09 -0400
Received: by lbbgj3 with SMTP id gj3so5804365lbb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 10:54:07 -0700 (PDT)
Message-ID: <505F4CBC.1000201@gmail.com>
Date: Sun, 23 Sep 2012 19:54:04 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com> <20120915145834.0b763f73@redhat.com> <5054C521.1090200@gmail.com> <20120915192530.74aedaa6@redhat.com> <50559241.6070408@gmail.com> <505844A0.30001@redhat.com> <5059C242.3010902@gmail.com> <5059F68F.4050009@redhat.com> <505A1C16.40507@gmail.com> <CAGncdOae+VoAAUWz3x84zUA-TCMeMmNONf_ktNFd1p7c-o5H_A@mail.gmail.com> <505C7E64.4040507@redhat.com> <8ed8c988-fa8c-41fc-9f33-cccdceb1b232@email.android.com> <505EF455.9080604@redhat.com>
In-Reply-To: <505EF455.9080604@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-23 13:36, Mauro Carvalho Chehab wrote:
> Em 22-09-2012 11:32, Anders Eriksson escreveu:
> >  Not to my knowledge. It's a standard antenna cable to my cabletv box. I watch tv over hdmi to get HD. I only use analogue (and this htpc card) to record stuff.
>
> (please, don't top-post - it makes harder to preserve the history of the
>   discussions)
Sorry about that. I was using my notsosmartphone.
>
> Then, maybe that's the reason why you're having troubles with this board.
>
> The tda8290-based devices have two components:
>
> 	1) a tda8275 tuner, at address 0x61 at the 7-bit I2C address notation
> 	  (or 0xc2, at the 8-bit notation);
> 	2) a tda8290 analog demod at address 0x4b (7-bit notation).
>
> Some devices provide a way to send power to a low noise amplifier located at the
> antenna or at the device itself (called LNA). The way to activate the LNA is
> board-dependent.
>
> On some devices the tda8290 can also be used to enable/disable a linear amplifier
> (LNA). Enabling/disabling the LNA and its gain affects the quality of the signal.
>
> In the case of tda8275/tda8290 based devices, the LNA setup type is stored at
> priv->cfg->config, where:
>
> 	0 - means no LNA control at all - device won't use it;
> 	1, 2 - LNA is via a pin at tda8290 (GPIO 0):
> 		When config is 1, LNA high gain happens writing a 0;
> 		When config is 2, LNA high gain happens writing a 1;
> 	3 - The LNA gain control is via a pin at saa713x.
>
> For modes 1 and 2, the switch_addr should be equal to 0x4b, as the commands
> sent to the device are for the tda8290 chip; sending them to tda8275 will
> likely produce no results or would affect something else there.
>
> I suspect that, in the case of your board, the LNA is at the antenna bundled
> together with the device. If I'm right, by enabling LNA, your board is sending
> some voltage through the cabling (you could easily check it with a voltmeter).
I actually have a multimeter somewhere. We're talking about the
antenna-in (unconnected) on the card, right? And what voltages
should I expect?
>
> What I think that your patch is actually doing is to disable LNA. As such, it
> should be equivalent to:
>
>
> diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
> index bc08f1d..98b482e 100644
> --- a/drivers/media/pci/saa7134/saa7134-cards.c
> +++ b/drivers/media/pci/saa7134/saa7134-cards.c
> @@ -3288,13 +3288,13 @@ struct saa7134_board saa7134_boards[] = {
>   		.name           = "Pinnacle PCTV 310i",
>   		.audio_clock    = 0x00187de7,
>   		.tuner_type     = TUNER_PHILIPS_TDA8290,
>   		.radio_type     = UNSET,
>   		.tuner_addr     = ADDR_UNSET,
>   		.radio_addr     = ADDR_UNSET,
> -		.tuner_config   = 1,
> +		.tuner_config   = 0,
>   		.mpeg           = SAA7134_MPEG_DVB,
>   		.gpiomask       = 0x000200000,
>   		.inputs         = {{
>   			.name = name_tv,
>   			.vmux = 4,
>   			.amux = TV,
>
>
> Please test if the above patch fixes the issue you're suffering[1]. If so, then
> we'll need to add a modprobe parameter to allow disabling LNA for saa7134 devices
> with LNA.
>
> [1] Note: the above is not the fix, as some users of this board may be using the
> original antenna, and changing tuner_config will break things for them; the right
> fix is likely to allow controlling the LNA via userspace.
Tried that patch on 3.5.3. No improvement, unfortunately.

Regards,
/Anders
