Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:61335 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZICFXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2009 01:23:48 -0400
Message-ID: <4A9F52E1.7030004@freemail.hu>
Date: Thu, 03 Sep 2009 07:23:45 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: "William M. Brack" <wbrack@mmm.com.hk>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: problem building v4l2-spec from docbook source
References: <4A9A3650.3000106@freemail.hu> <d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>
In-Reply-To: <d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

William M. Brack wrote:
> Németh Márton wrote:
>> Hi,
>>
>> I get the source from http://linuxtv.org/hg/v4l-dvb repository and I
>> am now
>> at version 12564:6f58a5d8c7c6. When I try to build the human readable
>> version
>> of the V4L2 specification I get some error message:
>>
>> $ make v4l2-spec
>> [...]
>> Using catalogs: /etc/sgml/catalog
>> Using stylesheet:
>> /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/custom.dsl#html
>> Working on: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml
>> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:1:55:W:
>> cannot generate system identifier for public text "-//OASIS//DTD
>> DocBook V3.1//EN"
>> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:23:0:E:
>> reference to entity "BOOK" for which no system identifier could be
>> generated
>> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:1:0: entity
>> was defined here
>> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:23:0:E: DTD
>> did not contain element declaration for document type name
>> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:25:9:E:
>> there is no attribute "ID"
>> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:25:19:E:
>> element "BOOK" undefined
> <snip>
>> openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml:367:11:E:
>> element "REVREMARK" undefined
>> openjade:I: maximum number of errors (200) reached; change with -E
>> option
>> make[2]: *** [html-single-build.stamp] Error 8
>> make[2]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l2-spec'
>> make[1]: *** [v4l2-spec] Error 2
>> make[1]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l'
>> make: *** [v4l2-spec] Error 2
>>
>> I am running Debian 5.0 with docbook-utils package version 0.6.14-1.1.
>> Any idea how to fix this?
>
> It appears you are missing one or more of the packages involved in the
> sgml catalog for docbook.  My first guess would be the sgml-common
> package; my second guess would be docbook-dtds.  After that, it gets
> more complicated - can you confirm you have those two and still have
> the problem?

Unfortunately the sgml-common and the docbook-dtds are not installed and
I cannot install them on Debian because they are not found:
http://packages.debian.org/search?keywords=sgml-common&searchon=names&suite=stable&section=all
http://packages.debian.org/search?suite=stable&section=all&arch=any&searchon=names&keywords=docbook-dtds

In the meantime I updated to version "12614:fd679bbd8bb3" and now I get
a different error message:

| $ make v4l2-spec
| [...]
| Using catalogs: /etc/sgml/catalog
| Using stylesheet: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/custom.dsl#html
| Working on: /usr/src/linuxtv.org/v4l-dvb/v4l2-spec/v4l2.sgml
| openjade:/usr/src/linuxtv.org/v4l-dvb/v4l2-spec/./remote_controllers.sgml:21:27:E: there is no attribute "Role"
| make[2]: *** [html-single-build.stamp] Error 8
| make[2]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l2-spec'
| make[1]: *** [v4l2-spec] Error 2
| make[1]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l'
| make: *** [v4l2-spec] Error 2

I have the following sgml and docbook related packages installed:

ii  libsgmls-perl                        1.03ii-32                      Perl modules for processing SGML parser outp
ii  sgml-base                            1.26                           SGML infrastructure and SGML catalog file su
ii  sgml-data                            2.0.3                          common SGML and XML data
ii  sgmlspl                              1.03ii-32                      SGMLS-based example Perl script for processi
ii  docbook-defguide                     2.0.17+svn7549-3               DocBook: The Definitive Guide - HTML version
ii  docbook-dsssl                        1.79-6                         modular DocBook DSSSL stylesheets, for print
ii  docbook-utils                        0.6.14-1.1                     Convert Docbook files to other formats (HTML
ii  docbook-xml                          4.5-6                          standard XML documentation system, for softw

Regards,

	Márton Németh

