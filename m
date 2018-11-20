Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24991 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbeKTVST (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 16:18:19 -0500
Date: Tue, 20 Nov 2018 12:49:46 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 for v4.4 1/1] v4l: event: Add subscription to list
 before calling "add" operation
Message-ID: <20181120104946.jgkotjrp6an76tws@paasikivi.fi.intel.com>
References: <20181114093746.29035-1-sakari.ailus@linux.intel.com>
 <20181119151400.GB5340@kroah.com>
 <20181119170354.kjgob6m2lsbqae2m@kekkonen.localdomain>
 <20181119174621.GA13098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119174621.GA13098@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Mon, Nov 19, 2018 at 06:46:21PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Nov 19, 2018 at 07:03:54PM +0200, Sakari Ailus wrote:
> > Hi Greg,
> > 
> > On Mon, Nov 19, 2018 at 04:14:00PM +0100, Greg Kroah-Hartman wrote:
> > > On Wed, Nov 14, 2018 at 11:37:46AM +0200, Sakari Ailus wrote:
> > > > [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
> > > 
> > > There is no such git commit id in Linus's tree :(
> > 
> > Right. At the moment it's in the media tree only. I expect it'll end up to
> > Linus's tree once Mauro will send the next pull request from the media tree
> > to Linus.
> 
> Ok, please do not send requests for stable tree inclusion until _AFTER_
> the patch is in Linus's tree, otherwise it just wastes the stable tree
> maintainer's time :(

Apologies for the noise. I'll send you a note once the patches are in
Linus's tree.

Thanks.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
