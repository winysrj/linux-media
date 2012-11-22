Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55251 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab2KVSvD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:51:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 133/493] remove use of __devexit_p
Date: Thu, 22 Nov 2012 11:36:14 +0100
Message-ID: <1908907.vq9PYUkhpZ@avalon>
In-Reply-To: <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu> <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 19 November 2012 13:21:22 Bill Pemberton wrote:
> CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
> needed.

[snip]

>  drivers/media/platform/omap3isp/isp.c                    | 2 +-

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

