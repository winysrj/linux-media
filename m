Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56576 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab2CLXJ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 19:09:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: James Hogan <james@albanarts.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.3] uvcvideo divide by 0 fix
Date: Tue, 13 Mar 2012 00:10:21 +0100
Message-ID: <6138844.b9r1FjnsQ8@avalon>
In-Reply-To: <201203112200.35422.hselasky@c2i.net>
References: <20120219234151.GA32005@balrog> <1689974.qoel1Ujv1I@avalon> <201203112200.35422.hselasky@c2i.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 11 March 2012 22:00:35 Hans Petter Selasky wrote:
> On Monday 20 February 2012 12:49:39 Laurent Pinchart wrote:
> > Hi Mauro,
> > 
> > The following changes since commit
> > 
> > b01543dfe67bb1d191998e90d20534dc354de059:
> >   Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable
> > 
> > The patch fixes a divide by 0 bug reported by a couple of users already.
> > Could you please make sure it gets into v3.3 ?
> > 
> > Laurent Pinchart (1):
> >       uvcvideo: Avoid division by 0 in timestamp calculation
> >  
> >  drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
> >  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> Has this patch been pulled back into media_tree.git ?

It doesn't seem so.

Mauro, could you please pull this ASAP ? v3.3 is very close.

-- 
Regards,

Laurent Pinchart

