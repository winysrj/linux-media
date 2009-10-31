Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:33061 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbZJaTKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 15:10:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/8] drivers/media/video/uvc: Use %pUl to print UUIDs
Date: Sat, 31 Oct 2009 20:10:39 +0100
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
References: <1254890742-28245-1-git-send-email-joe@perches.com> <200910120034.58943.laurent.pinchart@ideasonboard.com> <20091031070701.4ccf27d5@caramujo.chehab.org>
In-Reply-To: <20091031070701.4ccf27d5@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910312010.39785.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 31 October 2009 10:07:01 Mauro Carvalho Chehab wrote:
> Hi Laurent,
> 
> Em Mon, 12 Oct 2009 00:34:58 +0200
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > As this will go through the linuxtv v4l-dvb tree, I'll have to add
> > backward compatibility code (that will not make it to mainline). If
> > that's ok with you it will be easier for me to test and apply that part
> > of the patch through my tree once the vsprintf extension gets in.
> 
> I'm assuming that those printk patches from Joe to uvc will go via your
>  tree, so please submit a pull request when they'll be ready for upstream.

I'll submit the pull request as soon as the printk core patch hits upstream.

The change will break the driver when used with older versions (it will 
compile, load and run, but will print broken messages), and compat.h 
compatibility magic will not be possible. As the messages are purely 
informational, I'm pondering not even keeping #ifdef compatibility. Any 
thought on that ?

-- 
Regards,

Laurent Pinchart
