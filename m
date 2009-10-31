Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1158 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145AbZJaT1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 15:27:34 -0400
Subject: Re: [PATCH 5/8] drivers/media/video/uvc: Use %pUl to print UUIDs
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
In-Reply-To: <200910312010.39785.laurent.pinchart@ideasonboard.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
	 <200910120034.58943.laurent.pinchart@ideasonboard.com>
	 <20091031070701.4ccf27d5@caramujo.chehab.org>
	 <200910312010.39785.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 12:27:38 -0700
Message-ID: <1257017258.1917.138.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-10-31 at 20:10 +0100, Laurent Pinchart wrote:
> On Saturday 31 October 2009 10:07:01 Mauro Carvalho Chehab wrote:
> > I'm assuming that those printk patches from Joe to uvc will go via your
> >  tree, so please submit a pull request when they'll be ready for upstream.
> I'll submit the pull request as soon as the printk core patch hits upstream.

I believe Andrew Morton has picked up the patches for
his mm-commits set.  If you do nothing, these should
show up in Linus' tree after awhile.

lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch


