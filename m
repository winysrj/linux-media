Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41700 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbcGNCAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 22:00:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Linux Doc <linux-doc@vger.kernel.org>
Subject: Re: [ANN] Media documentation converted to ReST markup language
Date: Thu, 14 Jul 2016 05:00:47 +0300
Message-ID: <11676357.MV7iMPWTsY@avalon>
In-Reply-To: <20160713111143.20312bb9@recife.lan>
References: <20160708103420.27453f0d@recife.lan> <1602772.oBh27pyGSf@avalon> <20160713111143.20312bb9@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 13 Jul 2016 11:11:43 Mauro Carvalho Chehab wrote:
> Em Sat, 09 Jul 2016 20:10:21 +0300 Laurent Pinchart escreveu:
> > The other one is related, the table of contents in the main page of each
> > section
> > (https://mchehab.fedorapeople.org/media_API_book/linux_tv/media/v4l/v4l2.h
> > tml for instance) only shows the first level entries. We have a full table
> > of contents now, and that's very practical to quickly search for the
> > information we need without requiring many clicks (or actually any click
> > at all). How can we keep that feature ?
> 
> It is not hard to change the level of entries, although I really hated the
> DocBook template that creates multi-depth TOCs everywhere, as it is very
> messy to see those big indexes in the middle of the book.
> 
> What I did was to add *one* full contents index (actually, up to level 5)
> at the first page of the book:
> 	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/media_uapi.html
> 
> and kept the other ones with depth 1.

Thank you, that's exactly what I had in mind.

> > By the way, the "Video for Linux API" section (and the other sibling
> > sections) are child nodes of the "Introduction" section. That feels quite
> > odd.
>
> This was fixed already.

-- 
Regards,

Laurent Pinchart

