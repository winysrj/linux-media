Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm18-vm0.bullet.mail.ird.yahoo.com ([77.238.189.215]:35742 "HELO
	nm18-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751683Ab2C1HyC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 03:54:02 -0400
References: <1332797739.83006.YahooMailNeo@web171403.mail.ir2.yahoo.com> <4F719A35.30508@gmail.com>
Message-ID: <1332921240.54216.YahooMailNeo@web171402.mail.ir2.yahoo.com>
Date: Wed, 28 Mar 2012 08:54:00 +0100 (BST)
From: Sril <willy_the_cat@yahoo.com>
Reply-To: Sril <willy_the_cat@yahoo.com>
Subject: Re : AverTV Volar HD PRO : a return case.
To: "gennarone@gmail.com" <gennarone@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4F719A35.30508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>





> ----- Mail original -----
> De : Gianluca Gennari <gennarone@gmail.com>
> À : Sril <willy_the_cat@yahoo.com>; "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
> Cc : 
> Envoyé le : Mardi 27 mars 2012 12h45
> Objet : Re : AverTV Volar HD PRO : a return case.

> Il 26/03/2012 23:35, Sril ha scritto:
> > Hi,
> > 
> > Ianswer to mysel to say that I finally have a "working" 07ca:a835 under 3.0.26 kernel with xgazza_af9035 patch.
> > The one for 3.2.x crash part of kernel and I still have I2C regs that can not be read.
> > 
> > So, what tools must do I work on : patch for v4l (build_media) or patch for kernel from xgazza or af903x driver or whatever ?
> > Which one is under active building ?
> > 
> > Thanks for reply.
> > 
> > Best regards.
> > See ya.
>
> Hi Sril,
> the only af9035 driver currently under active development is the one
> from Hans-Frieder Vogt (af903x).

> The patch in attachment is a quick port of the support for the tda18218
> tuner (and hence the a835/b835 dongles) from the old drivers that are
> floating around (all derived from the xgazza patch).

> The problem with the xgazza patch is that it uses the tuner
> initialization script and the firmware of another stick (with a
> different tuner, the TUA 9001) so it is not working optimally. I have a
> 07ca:b835 and it works surprisingly well on my systems, but there are
> many users (like you) who report I2C errors.

> We need to extract a proper firmware and/or initialization script for
> the tda18218 from the Windows driver to solve this problems.

> There is also a small patch for the tda18218 that is needed to tune VHF
> frequencies (with 7MHz bandwidth).

> Best regards,
> Gianluca

Re,

Thanks for answer : god bless you :) !

After read : exactly what I expect. I needed to read this.
Will work on that road until that dvb dongle works.

Regards.
Sril

