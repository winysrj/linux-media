Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZIAAfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 20:35:38 -0400
Date: Mon, 31 Aug 2009 21:35:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "William M. Brack" <wbrack@mmm.com.hk>,
	"V4L Mailing List" <linux-media@vger.kernel.org>,
	=?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>
Subject: Re: problem building v4l2-spec from docbook source
Message-ID: <20090831213531.4eb2c10a@pedra.chehab.org>
In-Reply-To: <20090831135237.64d9442d@pedra.chehab.org>
References: <4A9A3650.3000106@freemail.hu>
	<d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>
	<20090831135237.64d9442d@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2009 13:52:37 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Hmm.. maybe Debian docbook packages have some issues with old versions of DocBook?
> Anyway, we should upgrade to XML 4.1.2 to use the same DocBook version as used on kernel.
> Also, as kernel uses xmlto, I'm working on a patch to port it to the same version/tools
> used on kernel. This will make easier for a future integration of the documentation at the
> kernel tree.

As promised, I just committed a changeset that upgraded the DocBook version. It
will now prefer to use xmlto, since, on my tests, it seemed more reliable than
docbook, for html targets. Unfortunately, it didn't work fine for pdf target,
so, it will keep using docbook (in fact db2pdf) for generating the pdf version.

Please test. It everything is fine, IMO, we should consider the inclusion of
the V4L2 API on kernel (or at least, some parts of the API - since the
"changes" chapter doesn't seem much relevant to be on kernel).



Cheers,
Mauro
