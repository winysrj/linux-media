Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbeKZSYI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 13:24:08 -0500
Date: Mon, 26 Nov 2018 08:30:52 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 for v4.4 1/1] v4l: event: Add subscription to list
 before calling "add" operation
Message-ID: <20181126073052.GA32373@kroah.com>
References: <20181114093746.29035-1-sakari.ailus@linux.intel.com>
 <20181119151400.GB5340@kroah.com>
 <20181119170354.kjgob6m2lsbqae2m@kekkonen.localdomain>
 <20181119174621.GA13098@kroah.com>
 <20181120104946.jgkotjrp6an76tws@paasikivi.fi.intel.com>
 <20181120092150.5c1bd063@coco.lan>
 <20181122113332.vl6pwnvpt54appbr@paasikivi.fi.intel.com>
 <20181126072759.GB18375@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126072759.GB18375@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 26, 2018 at 08:27:59AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Nov 22, 2018 at 01:33:33PM +0200, Sakari Ailus wrote:
> > On Tue, Nov 20, 2018 at 09:21:50AM -0200, Mauro Carvalho Chehab wrote:
> > > Em Tue, 20 Nov 2018 12:49:46 +0200
> > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > > 
> > > > Hi Greg,
> > > > 
> > > > On Mon, Nov 19, 2018 at 06:46:21PM +0100, Greg Kroah-Hartman wrote:
> > > > > On Mon, Nov 19, 2018 at 07:03:54PM +0200, Sakari Ailus wrote:  
> > > > > > Hi Greg,
> > > > > > 
> > > > > > On Mon, Nov 19, 2018 at 04:14:00PM +0100, Greg Kroah-Hartman wrote:  
> > > > > > > On Wed, Nov 14, 2018 at 11:37:46AM +0200, Sakari Ailus wrote:  
> > > > > > > > [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]  
> > > > > > > 
> > > > > > > There is no such git commit id in Linus's tree :(  
> > > > > > 
> > > > > > Right. At the moment it's in the media tree only. I expect it'll end up to
> > > > > > Linus's tree once Mauro will send the next pull request from the media tree
> > > > > > to Linus.  
> > > > > 
> > > > > Ok, please do not send requests for stable tree inclusion until _AFTER_
> > > > > the patch is in Linus's tree, otherwise it just wastes the stable tree
> > > > > maintainer's time :(  
> > > > 
> > > > Apologies for the noise. I'll send you a note once the patches are in
> > > > Linus's tree.
> > > 
> > > Btw, just sent a pull request with this patch. 
> > > 
> > > I wanted to send this two weeks ago, but I had to do two trips 
> > > (the final one to be at KS/LPC). This ended by delaying the pull request.
> > 
> > The patch is in Linus's tree now.
> 
> And what is the git commit id?

Nevermind, I see it...
