Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe09.c2i.net ([212.247.155.2]:43476 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751447Ab2CKVHR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 17:07:17 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR v3.3] uvcvideo divide by 0 fix
Date: Sun, 11 Mar 2012 22:00:35 +0100
Cc: James Hogan <james@albanarts.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <20120219234151.GA32005@balrog> <1689974.qoel1Ujv1I@avalon>
In-Reply-To: <1689974.qoel1Ujv1I@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203112200.35422.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 20 February 2012 12:49:39 Laurent Pinchart wrote:
> Hi Mauro,
> 
> The following changes since commit
> b01543dfe67bb1d191998e90d20534dc354de059:
> 
>   Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable
> 
> The patch fixes a divide by 0 bug reported by a couple of users already.
> Could you please make sure it gets into v3.3 ?
> 
> Laurent Pinchart (1):
>       uvcvideo: Avoid division by 0 in timestamp calculation
> 
>  drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)

Has this patch been pulled back into media_tree.git ?

--HPS
