Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZIANL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 09:11:58 -0400
Date: Tue, 1 Sep 2009 10:11:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"William M. Brack" <wbrack@mmm.com.hk>,
	"V4L Mailing List" <linux-media@vger.kernel.org>,
	=?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>
Subject: Re: problem building v4l2-spec from docbook source
Message-ID: <20090901101117.5868440d@pedra.chehab.org>
In-Reply-To: <61a1e1ecfcace9d2a452fa8de0521ab9.squirrel@webmail.xs4all.nl>
References: <4A9A3650.3000106@freemail.hu>
	<20090831213531.4eb2c10a@pedra.chehab.org>
	<200909010859.34027.hverkuil@xs4all.nl>
	<200909011049.15964.laurent.pinchart@ideasonboard.com>
	<61a1e1ecfcace9d2a452fa8de0521ab9.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 1 Sep 2009 10:55:10 +0200
"Hans Verkuil" <hverkuil@xs4all.nl> escreveu:

> 
> > On Tuesday 01 September 2009 08:59:33 Hans Verkuil wrote:
> >> On Tuesday 01 September 2009 02:35:31 Mauro Carvalho Chehab wrote:
> >> > Em Mon, 31 Aug 2009 13:52:37 -0300
> >> >
> >> > Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> >> > > Hmm.. maybe Debian docbook packages have some issues with old
> >> versions
> >> > > of DocBook? Anyway, we should upgrade to XML 4.1.2 to use the same
> >> > > DocBook version as used on kernel. Also, as kernel uses xmlto, I'm
> >> > > working on a patch to port it to the same version/tools used on
> >> kernel.
> >> > > This will make easier for a future integration of the documentation
> >> at
> >> > > the kernel tree.
> >> >
> >> > As promised, I just committed a changeset that upgraded the DocBook
> >> > version. It will now prefer to use xmlto, since, on my tests, it
> >> seemed
> >> > more reliable than docbook, for html targets. Unfortunately, it didn't
> >> > work fine for pdf target, so, it will keep using docbook (in fact
> >> db2pdf)
> >> > for generating the pdf version.
> >> >
> >> > Please test. It everything is fine, IMO, we should consider the
> >> inclusion
> >> > of the V4L2 API on kernel (or at least, some parts of the API - since
> >> the
> >> > "changes" chapter doesn't seem much relevant to be on kernel).
> >>
> >> Hi Mauro,
> >>
> >> I did a quick test of the html output and it seems that table handling
> >> is
> >> hit and miss: e.g. see section 1.9.5.1. 

IMHO, the spanspec is bad specified on this table. See if this would produce a
better result:

diff --git a/v4l2-spec/controls.sgml b/v4l2-spec/controls.sgml
--- a/v4l2-spec/controls.sgml
+++ b/v4l2-spec/controls.sgml
@@ -610,7 +610,7 @@ certain hardware.</para>
 	    <colspec colname="c3" colwidth="2*" />
 	    <colspec colname="c4" colwidth="6*" />
 	    <spanspec namest="c1" nameend="c2" spanname="id" />
-	    <spanspec namest="c2" nameend="c4" spanname="descr" />
+	    <spanspec namest="c3" nameend="c4" spanname="descr" />
 	    <thead>
 	      <row>
 		<entry spanname="id" align="left">ID</entry>

> In other cases there is very
> >> little
> >> space between columns, e.g. section 3.5, table 3.3.

Maybe it is not properly handling the colwidth. We need to do more investigation.

This DocBook version is less tolerant to standard violations. I had to fix
several violations that V3.1 didn't complain during the conversion. Maybe there
are some violations at the way some tables are specified, or maybe xmlto
doesn't care to colwidth or handles it differently.

> >> Regarding pdf: do we really want to keep that? The output never looked
> >> good. I wouldn't shed a tear if we dropped pdf support.
> >
> > Can't we fix it to make it look good instead ? :-)
> 
> I suspect that that is quite difficult: the core problem are some very
> wide tables that are cut off on the right hand side if I am not mistaken.

There are also some pictures that are cut.

> Of course, if someone wants to take this on...

It will be good if someone could fix it. I had to keep the old docbook2pdf to
generate pdf's since xmlto refuses to do it, mostly due to the size violations.



Cheers,
Mauro
