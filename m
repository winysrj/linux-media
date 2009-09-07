Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZIGHBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 03:01:19 -0400
Date: Mon, 7 Sep 2009 04:00:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Peter Brouwer <pb.maillists@googlemail.com>
Cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	"William M. Brack" <wbrack@mmm.com.hk>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: problem building v4l2-spec from docbook source
Message-ID: <20090907040048.369308a1@caramujo.chehab.org>
In-Reply-To: <20090906222525.73ada714@caramujo.chehab.org>
References: <4A9A3650.3000106@freemail.hu>
	<d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>
	<4A9F52E1.7030004@freemail.hu>
	<20090903085455.176f4df3@pedra.chehab.org>
	<20090903090847.4aeef6cc@pedra.chehab.org>
	<4AA12791.7070103@freemail.hu>
	<4AA2A5D3.2060508@googlemail.com>
	<20090906222525.73ada714@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 6 Sep 2009 22:25:25 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Sat, 05 Sep 2009 18:54:27 +0100
> Peter Brouwer <pb.maillists@googlemail.com> escreveu:
> 
> > Is it possible to create a link on the linuxtv.org website to the latest dvb and 
> > v4l spec in pdf?
> > For dvb the v3 is still on the documentation page.
> 
> The pdf version of V4L2 spec is currently broken: several tables and graphics
> don't fit at the page size. If you (or someone else) is interested on fixing
> it, I'll add a pointer at linuxtv.org  for the updated version, and improve the
> script to auto-generate it.
> 
> In the case of the DVB spec, the version of the current document is version 3.
> Patrick's ISDB-T patch series are increasing version to 5.1, but there are
> still some missing parts when comparing with the current API.
> 
> In order to make easier for people to maintain the DVB API and to allow people
> of just using just one language and document generation tools, I've converted the
> DVB API specs to DocBook as well. I'll add it to the tree soon. It is yet a
> work undergoing, but it would be nice if people could review it and improve.
> After having some review and porting the ISDB-T changes to it, IMO, the better
> is to deprecate the LaTex version using the DocBooc version one instead.
>

I've updated the Documentation page at linuxtv.org to warn people to not trust
at V4L2 spec pdf file, while nobody fixes it. I also added there a link to the
dvbapi spec generated via the newly DocBook port of the docs that I posted at:
	http://linuxtv.org/hg/~mchehab/dvb-specs

This way, it will be easier for people to double check if nothing were lost
during the format conversion. IMHO, one of the biggest advantage of the html
generated from DocBook is that the chapter/section numbering is preserved,
while, with the LaTex version, they are shown only at the pdf doc. It should be
noticed that, as no styles are applied to the tables, that they are not
nicely displayed at the DocBook version.



Cheers,
Mauro
