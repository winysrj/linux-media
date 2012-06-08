Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54962 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab2FHCqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 22:46:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Cc: Oleksij Rempel <bug-track@fisher-privat.net>,
	linux-uvc-devel@lists.sourceforge.net, sakari.ailus@iki.fi,
	linux-media@vger.kernel.org
Subject: Re: [linux-uvc-devel] [RFC] Media controller entity information ioctl [was "Re: [patch] suggestion for media framework"]
Date: Fri, 08 Jun 2012 04:46:37 +0200
Message-ID: <1915602.ON5YbSOUmP@avalon>
In-Reply-To: <CA+Dpati=kqq52JMu0gJBT=VeLGLXVgd3E-aY4YmfkXytMCDzyA@mail.gmail.com>
References: <4FCB9C12.1@fisher-privat.net> <9993866.a3VUSWRbyi@avalon> <CA+Dpati=kqq52JMu0gJBT=VeLGLXVgd3E-aY4YmfkXytMCDzyA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Monday 04 June 2012 10:11:33 Robert Krakora wrote:
> When you say "static" you mean items that are "well known" by the system by
> reading a registry at initialization?

By static I mean items that are initialized at driver initialization time and 
not modified afterwards. I don't think we should support adding/removing items 
at runtime, at least in the first version.

> When a new device exposes functionality that necessitates the creation of a
> new "static" item then how does the registry get updated to reflect this or
> am I misunderstanding?

Item types should be defined in a kernel header and documented. If a driver 
needs a new item types, the driver developer should add the new type to the 
header and document it.

-- 
Regards,

Laurent Pinchart
