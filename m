Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:39051 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1E1Idn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 04:33:43 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QQExp-0002G3-8D
	for linux-media@vger.kernel.org; Sat, 28 May 2011 10:33:41 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 28 May 2011 10:33:41 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 28 May 2011 10:33:41 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [linux-dvb] Terratec Cinergy C HD - CAM support.... Need help?
Date: Sat, 28 May 2011 10:33:16 +0200
Message-ID: <87wrhbql6b.fsf@nemi.mork.no>
References: <201105272148.04347.willem@ereprijs.demon.nl>
	<4DE002DB.8000304@dommel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-dvb@linuxtv.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Marc Coevoet <marcc@dommel.be> writes:
> Op 27-05-11 21:48, Willem van Asperen schreef:
>>
>> a) CAM support is currently not implemented for terratec HD
>
> For all cards?

The CA code in the mantis driver isn't actually hooked into the driver
anywhere, so that't correct: No CAM will currently work with the
Terratec Cinergy C HD.

Exported, but never called:

 bjorn@canardo:/usr/local/src/git/linux-2.6/drivers/media/dvb/mantis$ grep mantis_ca_init *.c
 mantis_ca.c:int mantis_ca_init(struct mantis_pci *mantis)
 mantis_ca.c:EXPORT_SYMBOL_GPL(mantis_ca_init);


I don't know why, but I assume it's the same as with the remote control
code that was recently fixed Christoph Pinkl: The code probably wasn't
considered production ready when the driver was merged, and was therefore
"temporarily" disabled until it could be fixed.


Bjørn

