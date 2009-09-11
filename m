Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2f.orange.fr ([80.12.242.150]:55448 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZIKHyr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 03:54:47 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2f04.orange.fr (SMTP Server) with ESMTP id 30ED580000A0
	for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 09:54:49 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2f04.orange.fr (SMTP Server) with ESMTP id 24B3D80000A9
	for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 09:54:49 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-42-204.w86-214.abo.wanadoo.fr [86.214.145.204])
	by mwinf2f04.orange.fr (SMTP Server) with ESMTP id A50F480000A0
	for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 09:54:48 +0200 (CEST)
Message-ID: <4AAA0247.8020004@gmail.com>
Date: Fri, 11 Sep 2009 09:54:47 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support, no
 idea what to try.
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com> <op.uzzfgyvj3xmt7q@crni> <4AA77240.2040504@gmail.com> <4AA77683.7010201@gmail.com> <4AA7C266.3000509@gmail.com> <op.uzzz96se6dn9rq@crni> <4AA7E166.7030906@gmail.com> <4AA81785.5000806@gmail.com> <4AA8BB20.4040701@gmail.com> <4AA919CA.20701@gmail.com>
In-Reply-To: <4AA919CA.20701@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

um .. help, please ?
how can i make the driver read 1011011 instead of 011011 when i press 
Power instead of record on the remote ?

thanks

Morvan Le Meut a écrit :
> from cx88-input.c
>
> case CX88_BOARD_ADSTECH_DVB_T_PCI:
>         ir_codes = ir_codes_adstech_dvb_t_pci;
>         ir->gpio_addr = MO_GP1_IO;
>         ir->mask_keycode = 0xbf;
>         ir->mask_keyup = 0x40;
>         ir->polling = 50; /* ms */
>         break;
>
> I'm not sure how much of the adstech instant tv dvb-t pci can be 
> copied for the non dvb-t one but could the solution be something along 
> the lines of that "ir->gpio_addr" thing ? or is that specific to the 
> cx88 driver ?
>



