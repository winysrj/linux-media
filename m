Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:43345 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbcCCAZY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 19:25:24 -0500
Date: Thu, 3 Mar 2016 09:25:13 +0900
From: Simon Horman <horms@verge.net.au>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] media: platform: rcar_jpu, sh_vou, vsp1: Use
 ARCH_RENESAS
Message-ID: <20160303002513.GG23040@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56D6E7D6.1010806@cogentembedded.com>
 <56D6CF57.2030507@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 02, 2016 at 12:32:39PM +0100, Hans Verkuil wrote:
> Hi Simon,
> 
> Note that the patch subject still mentions sh_vou.
> 
> Otherwise:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

[snip]

On Wed, Mar 02, 2016 at 04:17:10PM +0300, Sergei Shtylyov wrote:

[snip]

> >v2
> >* Do not update VIDEO_SH_VOU to use ARCH_RENESAS as this is
> >   used by some SH-based platforms and is not used by any ARM-based platforms
> >   so a dependency on ARCH_SHMOBILE is correct for that driver
> 
>    You forgot to remove it from the subject though.

[snip]


Thanks, I have posted v3 with sh_vou removed from the subject line.

