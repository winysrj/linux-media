Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46445
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbcGMOLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 10:11:49 -0400
Date: Wed, 13 Jul 2016 11:11:43 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Linux Doc <linux-doc@vger.kernel.org>
Subject: Re: [ANN] Media documentation converted to ReST markup language
Message-ID: <20160713111143.20312bb9@recife.lan>
In-Reply-To: <1602772.oBh27pyGSf@avalon>
References: <20160708103420.27453f0d@recife.lan>
	<1602772.oBh27pyGSf@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 09 Jul 2016 20:10:21 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> The other one is related, the table of contents in the main page of each 
> section 
> (https://mchehab.fedorapeople.org/media_API_book/linux_tv/media/v4l/v4l2.html 
> for instance) only shows the first level entries. We have a full table of 
> contents now, and that's very practical to quickly search for the information 
> we need without requiring many clicks (or actually any click at all). How can 
> we keep that feature ?

It is not hard to change the level of entries, although I really hated the
DocBook template that creates multi-depth TOCs everywhere, as it is very
messy to see those big indexes in the middle of the book.

What I did was to add *one* full contents index (actually, up to level 5)
at the first page of the book:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/media_uapi.html

and kept the other ones with depth 1.

> 
> By the way, the "Video for Linux API" section (and the other sibling sections) 
> are child nodes of the "Introduction" section. That feels quite odd.


This was fixed already.

Thanks,
Mauro
