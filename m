Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:54444 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZGDTgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jul 2009 15:36:38 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id ECB192D33A
	for <linux-media@vger.kernel.org>; Sat,  4 Jul 2009 21:36:36 +0200 (CEST)
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	rsc@pengutronix.de
Subject: Re: pxa_camera: Oops in pxa_camera_probe.
References: <20090701204325.2a277884.ospite@studenti.unina.it>
	<20090703161140.845950e8.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0907032200420.25247@axis700.grange>
	<20090703234148.b5aad4da.ospite@studenti.unina.it>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 04 Jul 2009 21:35:22 +0200
In-Reply-To: <20090703234148.b5aad4da.ospite@studenti.unina.it> (Antonio Ospite's message of "Fri\, 3 Jul 2009 23\:41\:48 +0200")
Message-ID: <87skhcfdhh.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antonio Ospite <ospite@studenti.unina.it> writes:

> On Fri, 3 Jul 2009 22:03:27 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>
>> On Fri, 3 Jul 2009, Antonio Ospite wrote:
>> 
>> > > Linux video capture interface: v2.00
>> > > Unable to handle kernel NULL pointer dereference at virtual address 00000060
>> > > pgd = c0004000
>> > > [00000060] *pgd=00000000
>> > > Internal error: Oops: f5 [#1] PREEMPT
>> > > Modules linked in:
>> > > CPU: 0    Tainted: G        W   (2.6.31-rc1-ezxdev #1)
>> > > PC is at dev_driver_string+0x0/0x38
>> > > LR is at pxa_camera_probe+0x144/0x428
>> > 
>> > The offending dev_driver_str() here is the one in the dev_warn() call in
>> > mclk_get_divisor().
>> > 
>> > This is what is happening: in struct pxacamera_platform_data I have:
>> > 	.mclk_10khz = 5000,
>> > 
>> > which makes the > test in mclk_get_divisor() succeed calling dev_warn
>> > to report that the clock has been limited, but pcdev->soc_host.dev is
>> > still uninitialized at this time.
Antonio,

Would you check [1] and see if your stack does correspond to the one I reported
some time ago ? As this is fresh in your memory, you'll be far quicker that me.

Ah, and by the way, I like your patch too, agree that mioa701 is touched, and I
think it should go upstream.

Cheers.

--
Robert

[1] http://osdir.com/ml/linux-media/2009-04/msg00874.html
