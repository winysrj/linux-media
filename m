Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65208 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2CMTbr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 15:31:47 -0400
Received: by iagz16 with SMTP id z16so1178053iag.19
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2012 12:31:47 -0700 (PDT)
Date: Tue, 13 Mar 2012 12:31:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH - stable v3.2] omap3isp: ccdc: Fix crash in HS/VS
 interrupt handler
Message-ID: <20120313193143.GB8568@kroah.com>
References: <1331467663-3735-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20120313180753.GA29074@kroah.com>
 <3242481.khdzXh3pyH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3242481.khdzXh3pyH@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 13, 2012 at 07:20:11PM +0100, Laurent Pinchart wrote:
> Hi Greg,
> 
> On Tuesday 13 March 2012 11:07:53 Greg KH wrote:
> > On Sun, Mar 11, 2012 at 01:07:43PM +0100, Laurent Pinchart wrote:
> > > The HS/VS interrupt handler needs to access the pipeline object. It
> > > erronously tries to get it from the CCDC output video node, which isn't
> > > necessarily included in the pipeline. This leads to a NULL pointer
> > > dereference.
> > > 
> > > Fix the bug by getting the pipeline object from the CCDC subdev entity.
> > > 
> > > The upstream commit ID is bcf45117d10140852fcdc2bfd36221dc8b996025.
> > 
> > In what tree?  I don't see that id in Linus's tree, are you sure you got
> > it correct?
> > 
> > confused,
> 
> I must have been confused as well :-/
> 
> The upstream commit ID is bd0f2e6da7ea9e225cb2dbd3229e25584b0e9538. Sorry for 
> the mistake.

No problem, now queued up, thanks.

greg k-h
