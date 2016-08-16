Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:56544 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbcHPLtL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 07:49:11 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH RFC v2 3/9] docs-rst: Don't mangle with UTF-8 chars on LaTeX/PDF output
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160816080338.56c6e5d1@vento.lan>
Date: Tue, 16 Aug 2016 13:48:13 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1C2F668D-41DD-4682-89D9-639430AAF3A6@darmarit.de>
References: <cover.1471294965.git.mchehab@s-opensource.com> <5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com> <4483E8C4-BBAC-4866-881D-3FBA5B85E834@darmarit.de> <20160816063605.6ef0ed27@vento.lan> <20160816080338.56c6e5d1@vento.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 16.08.2016 um 13:03 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 16 Aug 2016 06:36:05 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
> 2) the Latex auto-generated Makefile is hardcoded to use pdflatex. So,
> I had to manually replace it to xelatex. One easy solution would be to
> not use Make -C $BUILDDIR/latex, but to just call xelatex $BUILDDIR/$tex_name.

I recommend to ship your own tex-Makefile, see:

  https://lkml.org/lkml/2016/8/10/114

-- Markus 