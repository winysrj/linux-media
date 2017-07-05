Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34022 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750867AbdGEJc7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 05:32:59 -0400
Date: Wed, 5 Jul 2017 12:32:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: v4l2-fwnode: status, plans for merge, any branch to merge
 against?
Message-ID: <20170705093248.hndchnamibhqczfr@valkosipuli.retiisi.org.uk>
References: <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
 <20170704150819.GA10703@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170704150819.GA10703@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 04, 2017 at 05:08:19PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > Are there any news about the fwnode branch?
> > > > > 
> > > > > I have quite usable camera, but it is still based on
> > > > > 982e8e40390d26430ef106fede41594139a4111c (that's v4.10). It would be
> > > > > good to see fwnode stuff upstream... are there any plans for that?
> > > > > 
> > > > > Is there stable branch to which I could move the stuff?
> > > > 
> > > > What's relevant for most V4L2 drivers is in linux-media right now.
> > > > 
> > > > There are new features that will take some time to get in. The trouble has
> > > > been, and continue to be, that the patches need to go through various trees
> > > > so it'll take some time for them to be merged.
> > > > 
> > > > I expect to have most of them in during the next merge window.
> > > 
> > > So git://linuxtv.org/media_tree.git branch master is the right one to
> > > work one?
> > 
> > I also pushed the rebased ccp2 branch there:
> > 
> > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ccp2>
> > 
> > It's now right on the top of media-tree master.
> 
> Is ccp2 branch expected to go into 4.13, too?

Hi Pavel,

What I've done is just rebased the ccp2 branch. In other words, the patches
in that branch are no more ready than they were.

To get these merged we should ideally

1) Make sure there will be no regressions,

2) clean things up in the omap3isp; which resources are needed and when
(e.g. regulators, PHY configuration) isn't clear at the moment and

2) have one driver using the implementation.

At least 1) is needed. I think a number of framework patches could be
mergeable before 2) and 3) are done. I can prepare a set later this week.
But even that'd be likely for 4.14, not 4.13.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
