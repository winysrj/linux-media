Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086Ab1KCMNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 08:13:10 -0400
Message-ID: <4EB2854E.8010901@infradead.org>
Date: Thu, 03 Nov 2011 10:13:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 3/9 v6] V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF
 ioctl()s
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <1314813768-27752-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1314813768-27752-4-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-08-2011 15:02, Guennadi Liakhovetski escreveu:

...

> +<!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "v4l2.sgml"
> +indent-tabs-mode: nil
> +End:
> +-->


Please, don't add emacs crap into the files. This violates CodingStyle, and won't
bring anything to the file, as developers can use any editors to edit it, that
won't understand emacs specific stuff, and might want to add their own crap on it.

Don't bother re-sending me the entire series just due to that. It is easier to me
to just drop this when merging than to re-read the other 68 patches that are 
before this one.

Regards,
Mauro



