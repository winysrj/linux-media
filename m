Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44451 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab2CMSTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 14:19:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH - stable v3.2] omap3isp: ccdc: Fix crash in HS/VS interrupt handler
Date: Tue, 13 Mar 2012 19:20:11 +0100
Message-ID: <3242481.khdzXh3pyH@avalon>
In-Reply-To: <20120313180753.GA29074@kroah.com>
References: <1331467663-3735-1-git-send-email-laurent.pinchart@ideasonboard.com> <20120313180753.GA29074@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Tuesday 13 March 2012 11:07:53 Greg KH wrote:
> On Sun, Mar 11, 2012 at 01:07:43PM +0100, Laurent Pinchart wrote:
> > The HS/VS interrupt handler needs to access the pipeline object. It
> > erronously tries to get it from the CCDC output video node, which isn't
> > necessarily included in the pipeline. This leads to a NULL pointer
> > dereference.
> > 
> > Fix the bug by getting the pipeline object from the CCDC subdev entity.
> > 
> > The upstream commit ID is bcf45117d10140852fcdc2bfd36221dc8b996025.
> 
> In what tree?  I don't see that id in Linus's tree, are you sure you got
> it correct?
> 
> confused,

I must have been confused as well :-/

The upstream commit ID is bd0f2e6da7ea9e225cb2dbd3229e25584b0e9538. Sorry for 
the mistake.

-- 
Regards,

Laurent Pinchart

