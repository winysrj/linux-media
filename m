Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:36598 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbbESQoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 12:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
References: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 19 May 2015 17:44:14 +0100
Message-ID: <CA+V-a8upRG5r-r=YZUZrFWnD-x3QqeccNTJ7WuBHnMpTnFqL1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb drivers: use BUG_ON() instead of if () BUG
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antoine Jacquet <royale@zerezo.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2015 at 12:00 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Some USB drivers have a logic at the VB buffer handling like:
>         if (in_interrupt())
>                 BUG();
> Use, instead:
>         BUG_ON(in_interrupt());
>
> Btw, this logic looks weird on my eyes. We should convert them
> to use VB2, in order to avoid those crappy things.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
