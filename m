Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4501 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab1E1WiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 18:38:04 -0400
Received: from basedrum.localnet (ereprijs.demon.nl [83.161.20.106])
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id p4SMc1q1030993
	for <linux-media@vger.kernel.org>; Sun, 29 May 2011 00:38:01 +0200 (CEST)
	(envelope-from willem@ereprijs.demon.nl)
From: Willem van Asperen <willem@ereprijs.demon.nl>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Terratec Cinergy C HD - CAM support.... Need help?
Date: Sun, 29 May 2011 00:38:00 +0200
References: <201105272148.04347.willem@ereprijs.demon.nl> <4DE002DB.8000304@dommel.be> <87wrhbql6b.fsf@nemi.mork.no>
In-Reply-To: <87wrhbql6b.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105290038.01048.willem@ereprijs.demon.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 28 May 2011 10:33:16 Bjørn Mork wrote:
> Marc Coevoet <marcc@dommel.be> writes:
> > Op 27-05-11 21:48, Willem van Asperen schreef:
> >> a) CAM support is currently not implemented for terratec HD
> >
> > For all cards?
> 
> The CA code in the mantis driver isn't actually hooked into the driver
> anywhere, so that't correct: No CAM will currently work with the
> Terratec Cinergy C HD.
> 
> Exported, but never called:
> 
>  bjorn@canardo:/usr/local/src/git/linux-2.6/drivers/media/dvb/mantis$ grep
>  mantis_ca_init *.c mantis_ca.c:int mantis_ca_init(struct mantis_pci
>  *mantis)
>  mantis_ca.c:EXPORT_SYMBOL_GPL(mantis_ca_init);
> 
> 
> I don't know why, but I assume it's the same as with the remote control
> code that was recently fixed Christoph Pinkl: The code probably wasn't
> considered production ready when the driver was merged, and was therefore
> "temporarily" disabled until it could be fixed.
> 
> 
> Bjørn
Can anyone confirm this and, if so, is someone working on getting this fixed?

Like I said, happy to dig in and see if I can help here. But I would at least 
need to know what the current status is and an idea where the problem(s) sit.

Regards,
Willem
