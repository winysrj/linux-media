Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:51563 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751274AbaHLLCl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 07:02:41 -0400
Date: Tue, 12 Aug 2014 13:02:37 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] video: describe data bus formats
Message-ID: <20140812130237.36ec613e@bbrezillon>
In-Reply-To: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, 22 Jul 2014 14:23:42 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This patch series is a proposal to describe the different data formats used
> by HW components to connect with each other.
> 
> This is just a copy of the existing V4L2_MBUS_FMT defintions with a neutral
> name so that it can be used by V4L2 and DRM/KMS subsystem.
> 
> This series also makes use of this video_bus_format enum in the DRM/KMS
> subsystem to define the data fomats supported on the connector <-> device
> link.
> 
> The video bus formats are not documented yet (and I don't know where this doc
> should be stored), but I'm pretty sure this version won't be the last one ;-).

Laurent, Thierry (and other DRM/KMS folks), any comments on this
series ?

I'd really like to get the HLCDC driver mainlined for 3.18 and it
depends on this series now...

Best Regards,

Boris
-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
