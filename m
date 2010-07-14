Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39173 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0GNNNf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 09:13:35 -0400
Received: by pzk26 with SMTP id 26so1604464pzk.19
        for <linux-media@vger.kernel.org>; Wed, 14 Jul 2010 06:13:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilIUrBSvQXhPpMJOf4gqyztqy_OcGgfQYJ0IE2r@mail.gmail.com>
References: <AANLkTilzstvLDKE0VrXEw7awNLOLRVOyUpWpcf0B98HM@mail.gmail.com>
	<82429245-261C-49FF-962E-E768F66FB143@dons.net.au>
	<AANLkTilIUrBSvQXhPpMJOf4gqyztqy_OcGgfQYJ0IE2r@mail.gmail.com>
Date: Wed, 14 Jul 2010 23:13:33 +1000
Message-ID: <AANLkTinOTruTCuMcrbftiuEdd777qe_vJ1n1jloYqxQt@mail.gmail.com>
Subject: Re: Reception issue: DViCO Fusion HDTV DVB-T Dual Express
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: David Shirley <tephra@gmail.com>
Cc: "Daniel O'Connor" <darius@dons.net.au>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have this card (lspci reports pciid 14f1:8852, subsystem 18ac:db78)
and the Dual Digital 4 (lsusb 0fe9:db78).
I had a few problems similar to this (on Nine in Sydney, particularly)
until Mauro applied
some patches to fix some weirdness in the calculations of the tuning
offsets, a few months ago now. Now they are running reliably. I don't
know if the patches have made it into
mainstream distro kernels yet, but you should have them if you are
building the dvb drivers from the mercurial tree against the kernel
you have.

You may want to try dvbsnoop (http://www.linuxtv.org/wiki/index.php/Dvbsnoop)
to check on the mpeg streams. I haven't used it myself...

See also http://www.linuxtv.org/wiki/index.php/Testing_reception_quality
and http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device.

HTH
Vince

It may also help to load the driver module with the 'debug' option on.
