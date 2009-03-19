Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:62229 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZCSQwk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 12:52:40 -0400
Message-ID: <49C278D8.5010809@oracle.com>
Date: Thu, 19 Mar 2009 09:54:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 19 (media/video/au0828)
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
In-Reply-To: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090318:


when ADV_DEBUG=n:


drivers/media/video/au0828/au0828-video.c:1438: error: 'const struct v4l2_subdev_core_ops' has no member named 'g_register'
drivers/media/video/au0828/au0828-video.c:1453: error: 'const struct v4l2_subdev_core_ops' has no member named 's_register'


-- 
~Randy
