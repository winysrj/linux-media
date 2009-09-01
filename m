Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2398 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZIAIzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 04:55:32 -0400
Message-ID: <61a1e1ecfcace9d2a452fa8de0521ab9.squirrel@webmail.xs4all.nl>
In-Reply-To: <200909011049.15964.laurent.pinchart@ideasonboard.com>
References: <4A9A3650.3000106@freemail.hu>
    <20090831213531.4eb2c10a@pedra.chehab.org>
    <200909010859.34027.hverkuil@xs4all.nl>
    <200909011049.15964.laurent.pinchart@ideasonboard.com>
Date: Tue, 1 Sep 2009 10:55:10 +0200
Subject: Re: problem building v4l2-spec from docbook source
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"William M. Brack" <wbrack@mmm.com.hk>,
	"V4L Mailing List" <linux-media@vger.kernel.org>,
	=?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Tuesday 01 September 2009 08:59:33 Hans Verkuil wrote:
>> On Tuesday 01 September 2009 02:35:31 Mauro Carvalho Chehab wrote:
>> > Em Mon, 31 Aug 2009 13:52:37 -0300
>> >
>> > Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
>> > > Hmm.. maybe Debian docbook packages have some issues with old
>> versions
>> > > of DocBook? Anyway, we should upgrade to XML 4.1.2 to use the same
>> > > DocBook version as used on kernel. Also, as kernel uses xmlto, I'm
>> > > working on a patch to port it to the same version/tools used on
>> kernel.
>> > > This will make easier for a future integration of the documentation
>> at
>> > > the kernel tree.
>> >
>> > As promised, I just committed a changeset that upgraded the DocBook
>> > version. It will now prefer to use xmlto, since, on my tests, it
>> seemed
>> > more reliable than docbook, for html targets. Unfortunately, it didn't
>> > work fine for pdf target, so, it will keep using docbook (in fact
>> db2pdf)
>> > for generating the pdf version.
>> >
>> > Please test. It everything is fine, IMO, we should consider the
>> inclusion
>> > of the V4L2 API on kernel (or at least, some parts of the API - since
>> the
>> > "changes" chapter doesn't seem much relevant to be on kernel).
>>
>> Hi Mauro,
>>
>> I did a quick test of the html output and it seems that table handling
>> is
>> hit and miss: e.g. see section 1.9.5.1. In other cases there is very
>> little
>> space between columns, e.g. section 3.5, table 3.3.
>>
>> Regarding pdf: do we really want to keep that? The output never looked
>> good. I wouldn't shed a tear if we dropped pdf support.
>
> Can't we fix it to make it look good instead ? :-)

I suspect that that is quite difficult: the core problem are some very
wide tables that are cut off on the right hand side if I am not mistaken.

Of course, if someone wants to take this on...

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

