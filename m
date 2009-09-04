Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:64510 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbZIDOnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 10:43:33 -0400
Message-ID: <4AA12791.7070103@freemail.hu>
Date: Fri, 04 Sep 2009 16:43:29 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "William M. Brack" <wbrack@mmm.com.hk>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: problem building v4l2-spec from docbook source
References: <4A9A3650.3000106@freemail.hu>	<d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>	<4A9F52E1.7030004@freemail.hu>	<20090903085455.176f4df3@pedra.chehab.org> <20090903090847.4aeef6cc@pedra.chehab.org>
In-Reply-To: <20090903090847.4aeef6cc@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Thu, 3 Sep 2009 08:54:55 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> 
>> Em Thu, 03 Sep 2009 07:23:45 +0200
>> Németh Márton <nm127@freemail.hu> escreveu:
>>
>>
>> Try to replace "Role" to "role". Maybe it is just another case where you need to use lowercase with some xml engines.
> 
> Ok, I just added a patch that does this to remote_controllers.sgml:
> 
> -<row><entry><emphasis Role="bold">Miscelaneous keys</emphasis></entry></row>
> +<row><entry><emphasis role="bold">Miscelaneous keys</emphasis></entry></row>
> 
> changeset:   12615:2b49813f8482
> tag:         tip
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Thu Sep 03 09:06:34 2009 -0300
> summary:     v4l2-spec: Fix xmlto compilation with some versions of the tool
> 
> Please see if this fixes the issue.

Thanks, now the "make v4l2-spec" successfully build the html documentation
on my computer.

Regards,

	Márton Németh
