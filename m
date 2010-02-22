Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57959 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab0BVVwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 16:52:25 -0500
Message-ID: <4B82FC95.9070301@infradead.org>
Date: Mon, 22 Feb 2010 18:52:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Updated videobuf documentation
References: <20100218101219.665c5403@bike.lwn.net>	<4B7DC652.9080601@xenotime.net>	<4B7E2B0F.6000706@infradead.org> <20100222134746.1ce5cecf@bike.lwn.net> <4B82F542.2030206@xenotime.net>
In-Reply-To: <4B82F542.2030206@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy Dunlap wrote:
> On 02/22/10 12:47, Jonathan Corbet wrote:
>> On Fri, 19 Feb 2010 04:09:19 -0200
>> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>>
>>> Not anymore: there's a patch that added USERPTR support for videobuf-dma-contig:
>>>
>>> commit 720b17e759a50635c429ccaa2ec3d01edb4f92d6
>>> Author: Magnus Damm <damm@igel.co.jp>
>>> Date:   Tue Jun 16 15:32:36 2009 -0700
>>>
>>>     videobuf-dma-contig: zero copy USERPTR support
>> Now *that* is a special-purpose hack.  But it's worth mentioning, so
>> I've updated the text accordingly.
>>
>>> In terms of memory types, there's a possibility that weren't mentioned: the OVERLAY mode.
>>>
>>> Maybe a small paragraph may be added just for the completeness of the doc.
>> Yeah, I try to ignore overlay whenever I can.  I've added a brief bit.
>>
>> New version of the patch attached; look better?
> 
> Looks good to me (other than a few straggling lines that end with whitespace).
> 
> Reviewed-by: Randy Dunlap <rdunlap@xenotime.net>

Seems OK to me also. I'll apply it (running a script to remove trailing whitespaces ;) )


-- 

Cheers,
Mauro
