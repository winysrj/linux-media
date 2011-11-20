Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:48226 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1KTU1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 15:27:54 -0500
Received: from basile.remlab.net (cs27062010.pp.htv.fi [89.27.62.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by yop.chewa.net (Postfix) with ESMTPSA id 134871AF
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 21:27:53 +0100 (CET)
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] [media] dvb: Allow select between DVB-C Annex A and Annex C
Date: Sun, 20 Nov 2011 22:27:48 +0200
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111202227.48948.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le dimanche 20 novembre 2011 16:56:11 Mauro Carvalho Chehab, vous avez écrit :
> DVB-C, as defined by ITU-T J.83 has 3 annexes. The differences between
> Annex A and Annex C is that Annex C uses a subset of the modulation
> types, and uses a different rolloff factor. A different rolloff means
> that the bandwidth required is slicely different, and may affect the
> saw filter configuration at the tuners. Also, some demods have different
> configurations, depending on using Annex A or Annex C.
> 
> So, allow userspace to specify it, by changing the rolloff factor.

I assume you'll bump the minor DVB version at some point too?

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
