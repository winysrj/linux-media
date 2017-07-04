Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33668 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbdGDPIZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 11:08:25 -0400
Date: Tue, 4 Jul 2017 17:08:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: v4l2-fwnode: status, plans for merge, any branch to merge
 against?
Message-ID: <20170704150819.GA10703@localhost>
References: <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > > > Are there any news about the fwnode branch?
> > > > 
> > > > I have quite usable camera, but it is still based on
> > > > 982e8e40390d26430ef106fede41594139a4111c (that's v4.10). It would be
> > > > good to see fwnode stuff upstream... are there any plans for that?
> > > > 
> > > > Is there stable branch to which I could move the stuff?
> > > 
> > > What's relevant for most V4L2 drivers is in linux-media right now.
> > > 
> > > There are new features that will take some time to get in. The trouble has
> > > been, and continue to be, that the patches need to go through various trees
> > > so it'll take some time for them to be merged.
> > > 
> > > I expect to have most of them in during the next merge window.
> > 
> > So git://linuxtv.org/media_tree.git branch master is the right one to
> > work one?
> 
> I also pushed the rebased ccp2 branch there:
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ccp2>
> 
> It's now right on the top of media-tree master.

Is ccp2 branch expected to go into 4.13, too?

Best regards,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
