Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZHaQwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 12:52:43 -0400
Date: Mon, 31 Aug 2009 13:52:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "William M. Brack" <wbrack@mmm.com.hk>
Cc: "V4L Mailing List" <linux-media@vger.kernel.org>,
	=?ISO-8859-1?B?Tult?= =?ISO-8859-1?B?ZXRoIE3hcnRvbg==?=
	<nm127@freemail.hu>
Subject: Re: problem building v4l2-spec from docbook source
Message-ID: <20090831135237.64d9442d@pedra.chehab.org>
In-Reply-To: <d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>
References: <4A9A3650.3000106@freemail.hu>
	<d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2009 05:42:18 -0700
"William M. Brack" <wbrack@mmm.com.hk> escreveu:

> Németh Márton wrote:
> > Hi,
> >
> > I get the source from http://linuxtv.org/hg/v4l-dvb repository and I
> > am now
> > at version 12564:6f58a5d8c7c6. When I try to build the human readable
> > version
> > of the V4L2 specification I get some error message:
> >
> > $ make v4l2-spec
> > [...]
> > Using catalogs: /etc/sgml/catalog
> > Using stylesheet:
> > /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/custom.dsl#html
> > Working on: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml
> > openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:1:55:W:
> > cannot generate system identifier for public text "-//OASIS//DTD
> > DocBook V3.1//EN"
> > openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:23:0:E:
> > reference to entity "BOOK" for which no system identifier could be
> > generated
> > openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:1:0: entity
> > was defined here
> > openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:23:0:E: DTD
> > did not contain element declaration for document type name
> > openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:25:9:E:
> > there is no attribute "ID"
> > openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:25:19:E:
> > element "BOOK" undefined
> <snip>
> > openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:367:11:E:
> > element "REVREMARK" undefined
> > openjade:I: maximum number of errors (200) reached; change with -E
> > option
> > make[2]: *** [html-single-build.stamp] Error 8
> > make[2]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l2-spec'
> > make[1]: *** [v4l2-spec] Error 2
> > make[1]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l'
> > make: *** [v4l2-spec] Error 2
> >
> > I am running Debian 5.0 with docbook-utils package version 0.6.14-1.1.
> > Any idea how to fix this?
> >
> > Regards,
> >
> > 	Márton Németh
> It appears you are missing one or more of the packages involved in the
> sgml catalog for docbook.  My first guess would be the sgml-common
> package; my second guess would be docbook-dtds.  After that, it gets
> more complicated - can you confirm you have those two and still have
> the problem?

Hmm.. maybe Debian docbook packages have some issues with old versions of DocBook?
Anyway, we should upgrade to XML 4.1.2 to use the same DocBook version as used on kernel.
Also, as kernel uses xmlto, I'm working on a patch to port it to the same version/tools
used on kernel. This will make easier for a future integration of the documentation at the
kernel tree.
> 
> Bill
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
