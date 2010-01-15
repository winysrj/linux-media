Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:33319 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0AOQ4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 11:56:46 -0500
Date: Fri, 15 Jan 2010 08:55:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] obsolete config in kernel source (FB_SOFT_CURSOR)
Message-Id: <20100115085558.4d908605.randy.dunlap@oracle.com>
In-Reply-To: <20100115122755.GC3321@faui49.informatik.uni-erlangen.de>
References: <20100115122755.GC3321@faui49.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Jan 2010 13:27:56 +0100 Christoph Egger wrote:

> Hi all!
> 
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
> 
> 	While probably not strictly a integrity violation (as
> FB_SOFT_CURSOR can still be set as it is once mentioned in a KConfig
> select statement this looks like a left-over of
> c465e05a03209651078b95686158648fd7ed84c5
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
> 
> Regards
> 
> 	Christoph Egger
> 
> [0] http://vamos1.informatik.uni-erlangen.de/

Hi,

This one should have gone to the linux-fbdev@vger.kernel.org mailing list
instead of linux-media.

http://vger.kernel.org/vger-lists.html#linux-fbdev

---
~Randy
