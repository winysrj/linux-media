Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3090 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1E2Mk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 08:40:56 -0400
Received: from basedrum.localnet (ereprijs.demon.nl [83.161.20.106])
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id p4TCeox0071338
	for <linux-media@vger.kernel.org>; Sun, 29 May 2011 14:40:54 +0200 (CEST)
	(envelope-from willem@ereprijs.demon.nl)
From: Willem van Asperen <willem@ereprijs.demon.nl>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Terratec Cinergy C HD - CAM support.... Need help?
Date: Sun, 29 May 2011 14:40:49 +0200
References: <201105272148.04347.willem@ereprijs.demon.nl> <201105291142.33876.willem@ereprijs.demon.nl> <87oc2lr9jo.fsf@nemi.mork.no>
In-Reply-To: <87oc2lr9jo.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105291440.49845.willem@ereprijs.demon.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 29 May 2011 14:11:23 Bjørn Mork wrote:
> Willem van Asperen <willem@ereprijs.demon.nl> writes:
> > Actually, doing this on s2-liplianin-41388e396e0f (the one I downloaded
> > today) gets:
> > $ grep mantis_ca_init *.c
> >
> > mantis_ca.c:int mantis_ca_init(struct mantis_pci *mantis)
> > mantis_dvb.c:   mantis_ca_init(mantis);
> >
> > And in the function __devinit mantis_dvb_init(struct mantis_pci *mantis)
> > it actually says:
> >
> > ...
> > 	dvb_net_init(&mantis->dvb_adapter, &mantis->dvbnet, &mantis->demux.dmx);
> > 	tasklet_init(&mantis->tasklet, mantis_dma_xfer, (unsigned long) mantis);
> > 	mantis_frontend_init(mantis);
> > 	mantis_ca_init(mantis);
> >
> > 	return 0;
> > ...
> >
> > So it seems that this mantis_ca_init call is actually made nowadays.
> 
> In the s2-liplianin yes.  Not in mainline.  Investigating the
> differences might be useful.

Indeed.

% modprobe -r mantis
% modprobe mantis

gives:
May 29 14:37:51 mythbox kernel: Mantis 0000:03:02.0: PCI INT A -> GSI 17 
(level, low) -> IRQ 17
May 29 14:37:51 mythbox kernel: DVB: registering new adapter (Mantis DVB 
adapter)
May 29 14:37:52 mythbox kernel: DVB: registering adapter 0 frontend 0 (Philips 
TDA10023 DVB-C)...


Nothing about CA

