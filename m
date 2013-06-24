Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40921 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3FXKBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 06:01:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wouter Thielen <wouter@morannon.org>
Cc: linux-media@vger.kernel.org
Subject: Re: Mistake on the colorspace page in the API doc
Date: Mon, 24 Jun 2013 12:02 +0200
Message-ID: <13069777.Dd9JLWaoF2@avalon>
In-Reply-To: <CACySJQUvkv4+x5UborCRHs=V20bzx5r7A2zgvecEkvcb8kQhUA@mail.gmail.com>
References: <CACySJQX-GUYax5MPounyFCUczgncPx=SV=8O6ORd_zwfn31jkQ@mail.gmail.com> <19880516.7ZPIjvT6Bx@avalon> <CACySJQUvkv4+x5UborCRHs=V20bzx5r7A2zgvecEkvcb8kQhUA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wouter,

On Monday 24 June 2013 14:47:30 Wouter Thielen wrote:
> Hi Laurent,
> 
> Sorry for the late reply. I'll post a patch of your revised version,
> but I don't see the documentation anywhere in your git repositories. I
> guess I'll download the file (preserving directory structure), update
> it, and send you a diff -run. If this is not how it is done, please
> let me know.

The documentation is located in the kernel sources. The file you're looking 
for is Documentation/DocBook/media/v4l/pixfmt.xml. It can be compiled to html 
by running

make htmldocs

in the root directory of the kernel tree.

-- 
Regards,

Laurent Pinchart

