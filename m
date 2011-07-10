Return-path: <mchehab@localhost>
Received: from yop.chewa.net ([91.121.105.214]:34141 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab1GJNpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 09:45:51 -0400
Received: from basile.remlab.net (cs27062010.pp.htv.fi [89.27.62.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by yop.chewa.net (Postfix) with ESMTPSA id 84F4F107B
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 15:45:49 +0200 (CEST)
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [Patch] dvb-apps: add test tool for DMX_OUT_TSDEMUX_TAP
Date: Sun, 10 Jul 2011 16:45:46 +0300
References: <20110710124303.26655303@susi.home.s3e.de>
In-Reply-To: <20110710124303.26655303@susi.home.s3e.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107101645.47915.remi@remlab.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Le dimanche 10 juillet 2011 13:43:03 Stefan Seyfried, vous avez écrit :
> Hi all,
> 
> I patched test_dvr to use DMX_OUT_TSDEMUX_TAP and named it test_tapdmx.
> Might be useful for others, too :-)
> This is my first experience with mercurial, so bear with me if it's
> totally wrong.

Did it work for you? We at VideoLAN.org could not get DMX_OUT_TSDEMUX_TAP to 
work with any of three distinct device/drivers (on two different delivery 
systems). We do get TS packets, but they seem to be partly corrupt.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
