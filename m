Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730035AbeKTEKy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 23:10:54 -0500
Date: Mon, 19 Nov 2018 18:46:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 for v4.4 1/1] v4l: event: Add subscription to list
 before calling "add" operation
Message-ID: <20181119174621.GA13098@kroah.com>
References: <20181114093746.29035-1-sakari.ailus@linux.intel.com>
 <20181119151400.GB5340@kroah.com>
 <20181119170354.kjgob6m2lsbqae2m@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119170354.kjgob6m2lsbqae2m@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 19, 2018 at 07:03:54PM +0200, Sakari Ailus wrote:
> Hi Greg,
> 
> On Mon, Nov 19, 2018 at 04:14:00PM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Nov 14, 2018 at 11:37:46AM +0200, Sakari Ailus wrote:
> > > [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
> > 
> > There is no such git commit id in Linus's tree :(
> 
> Right. At the moment it's in the media tree only. I expect it'll end up to
> Linus's tree once Mauro will send the next pull request from the media tree
> to Linus.

Ok, please do not send requests for stable tree inclusion until _AFTER_
the patch is in Linus's tree, otherwise it just wastes the stable tree
maintainer's time :(

greg k-h
