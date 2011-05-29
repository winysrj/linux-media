Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:51749 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1E2MLm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 08:11:42 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QQeqL-00057d-2x
	for linux-media@vger.kernel.org; Sun, 29 May 2011 14:11:41 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 29 May 2011 14:11:41 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 29 May 2011 14:11:41 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [linux-dvb] Terratec Cinergy C HD - CAM support.... Need help?
Date: Sun, 29 May 2011 14:11:23 +0200
Message-ID: <87oc2lr9jo.fsf@nemi.mork.no>
References: <201105272148.04347.willem@ereprijs.demon.nl>
	<4DE002DB.8000304@dommel.be> <87wrhbql6b.fsf@nemi.mork.no>
	<201105291142.33876.willem@ereprijs.demon.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Willem van Asperen <willem@ereprijs.demon.nl> writes:

> Actually, doing this on s2-liplianin-41388e396e0f (the one I downloaded today) 
> gets:
> $ grep mantis_ca_init *.c
>
> mantis_ca.c:int mantis_ca_init(struct mantis_pci *mantis)
> mantis_dvb.c:   mantis_ca_init(mantis);
>
> And in the function __devinit mantis_dvb_init(struct mantis_pci *mantis) it 
> actually says:
>
> ...
> 	dvb_net_init(&mantis->dvb_adapter, &mantis->dvbnet, &mantis->demux.dmx);
> 	tasklet_init(&mantis->tasklet, mantis_dma_xfer, (unsigned long) mantis);
> 	mantis_frontend_init(mantis);
> 	mantis_ca_init(mantis);
>
> 	return 0;
> ...
>
> So it seems that this mantis_ca_init call is actually made nowadays.

In the s2-liplianin yes.  Not in mainline.  Investigating the
differences might be useful.


Bjørn

