Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50510 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbZLWXpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 18:45:25 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NNatP-0002qJ-6L
	for linux-media@vger.kernel.org; Thu, 24 Dec 2009 00:45:23 +0100
Received: from upc.si.94.140.72.111.dc.cable.static.telemach.net ([94.140.72.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 00:45:23 +0100
Received: from prusnik by upc.si.94.140.72.111.dc.cable.static.telemach.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 00:45:23 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alja=C5=BE?= Prusnik <prusnik@gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
Date: Thu, 24 Dec 2009 00:45:02 +0100
Message-ID: <1261611901.8948.37.camel@slash.doma>
References: <4B1D6194.4090308@freenet.de>
	 <1261578615.8948.4.camel@slash.doma> <200912231753.28988.liplianin@me.by>
	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>
	 <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On sre, 2009-12-23 at 23:24 +0400, Manu Abraham wrote:
> > Aljaz, do you have the module mantis.ko?
> There was a build issue when i posted the link originally, but it had
> been fixed..
> 
> manu@manu-04:/stor/work/merge/v4l-dvb/v4l> ls *.ko |grep mantis
> mantis_core.ko
> mantis.ko
> 

Yup, I have both of them. I just compiled http://jusst.de/hg/v4l-dvb
again and the result is (depmode -a was run):

- ir-common.ko is under drivers/media/common (not drivers/media/IR like
Igor suggested but that is probably because it's a different
repository).
- mantis.ko and mantis_core.ko are under drivers/media/dvb/mantis

The modules loaded are:
mantis                 14728  0 
mantis_core            23909  12 mantis
ir_common              27005  1 mantis_core
mb86a16                16598  1 mantis
tda10021                4822  1 mantis
tda10023                5823  1 mantis
zl10353                 5893  1 mantis
stv0299                 7860  1 mantis
dvb_core               75201  2 mantis_core,stv0299

kernel log has only these lines on mantis:
Mantis 0000:03:07.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
DVB: registering new adapter (Mantis DVB adapter)
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...

and that's it. No VP-2040 to be seen anywhere and it's not there even if
I do cat /proc/bus/input/devices (used to be one of the inputs).

So I guess this is now the work in progress if I understand correctly or
should the input be recognized regardless?

Just to confirm on the autoload: no, it does not happen by default. I
have to manually put modules under /etc/modules to load them on startup.

Regards,
Aljaz


