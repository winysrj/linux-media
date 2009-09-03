Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbZICLzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2009 07:55:36 -0400
Date: Thu, 3 Sep 2009 08:54:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>
Cc: "William M. Brack" <wbrack@mmm.com.hk>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: problem building v4l2-spec from docbook source
Message-ID: <20090903085455.176f4df3@pedra.chehab.org>
In-Reply-To: <4A9F52E1.7030004@freemail.hu>
References: <4A9A3650.3000106@freemail.hu>
	<d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>
	<4A9F52E1.7030004@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Sep 2009 07:23:45 +0200
Németh Márton <nm127@freemail.hu> escreveu:

> William M. Brack wrote:
> > Németh Márton wrote:
> >> Hi,
> >>
> >> I get the source from http://linuxtv.org/hg/v4l-dvb repository and I
> >> am now
> >> at version 12564:6f58a5d8c7c6. When I try to build the human readable
> >> version
> >> of the V4L2 specification I get some error message:
> >>
> >> $ make v4l2-spec
> >> [...]
> >> Using catalogs: /etc/sgml/catalog
> >> Using stylesheet:
> >> /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/custom.dsl#html
> >> Working on: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml
> >> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:1:55:W:
> >> cannot generate system identifier for public text "-//OASIS//DTD
> >> DocBook V3.1//EN"
> >> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:23:0:E:
> >> reference to entity "BOOK" for which no system identifier could be
> >> generated
> >> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:1:0: entity
> >> was defined here
> >> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:23:0:E: DTD
> >> did not contain element declaration for document type name
> >> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:25:9:E:
> >> there is no attribute "ID"
> >> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:25:19:E:
> >> element "BOOK" undefined
> > <snip>
> >> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:367:11:E:
> >> element "REVREMARK" undefined
> >> openjade:I: maximum number of errors (200) reached; change with -E
> >> option
> >> make[2]: *** [html-single-build.stamp] Error 8
> >> make[2]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l2-spec'
> >> make[1]: *** [v4l2-spec] Error 2
> >> make[1]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l'
> >> make: *** [v4l2-spec] Error 2
> >>
> >> I am running Debian 5.0 with docbook-utils package version 0.6.14-1.1.
> >> Any idea how to fix this?
> >
> > It appears you are missing one or more of the packages involved in the
> > sgml catalog for docbook.  My first guess would be the sgml-common
> > package; my second guess would be docbook-dtds.  After that, it gets
> > more complicated - can you confirm you have those two and still have
> > the problem?
> 
> Unfortunately the sgml-common and the docbook-dtds are not installed and
> I cannot install them on Debian because they are not found:
> http://packages.debian.org/search?keywords=sgml-common&searchon=names&suite=stable&section=all
> http://packages.debian.org/search?suite=stable&section=all&arch=any&searchon=names&keywords=docbook-dtds
> 
> In the meantime I updated to version "12614:fd679bbd8bb3" and now I get
> a different error message:
> 
> | $ make v4l2-spec
> | [...]
> | Using catalogs: /etc/sgml/catalog
> | Using stylesheet: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/custom.dsl#html
> | Working on: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml
> | openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/./remote_controllers.sgml:21:27:E: there is no attribute "Role"

Try to replace "Role" to "role". Maybe it is just another case where you need to use lowercase with some xml engines.



Cheers,
Mauro
