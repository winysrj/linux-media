Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33247 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756130AbaJHLdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Oct 2014 07:33:38 -0400
Date: Wed, 8 Oct 2014 14:33:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alaganraj Sandhanam <alaganraj.sandhanam@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: omap3isp Device Tree support status
Message-ID: <20141008113303.GY2939@valkosipuli.retiisi.org.uk>
References: <20140928221341.GQ2939@valkosipuli.retiisi.org.uk>
 <54330499.50905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54330499.50905@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alaganjar,

On Tue, Oct 07, 2014 at 02:37:37AM +0530, Alaganraj Sandhanam wrote:
> Hi Sakari,
> 
> Thanks for the patches.
> On Monday 29 September 2014 03:43 AM, Sakari Ailus wrote:
> > Hi,
> > 
> > I managed to find some time for debugging my original omap3isp DT support
> > patchset (which includes smiapp DT support as well), and found a few small
> > but important bugs.
> > 
> > The status is now that images can be captured using the Nokia N9 camera, in
> > which the sensor is connected to the CSI-2 interface. Laurent confirmed that
> > the parallel interface worked for him (Beagleboard, mt9p031 sensor on
> > Leopard imaging's li-5m03 board).
> Good news!
> > 
> > These patches (on top of the smiapp patches I recently sent for review which
> > are in much better shape) are still experimental and not ready for review. I
> > continue to clean them up and post them to the list when that is done. For
> > now they can be found here:
> > 
> > <URL:http://git.linuxtv.org/cgit.cgi/sailus/media_tree.git/log/?h=rm696-043-dt>
> > 
> I couldn't clone the repo, getting "remote corrupt" error.
> 
> $ git remote -v
> media-sakari	git://linuxtv.org/sailus/media_tree.git (fetch)
> media-sakari	git://linuxtv.org/sailus/media_tree.git (push)
> origin	git://linuxtv.org/media_tree.git (fetch)
> origin	git://linuxtv.org/media_tree.git (push)
> sakari	git://vihersipuli.retiisi.org.uk/~sailus/linux.git (fetch)
> sakari	git://vihersipuli.retiisi.org.uk/~sailus/linux.git (push)
> 
> $ git fetch media-sakari
> warning: cannot parse SRV response: Message too long
> remote: error: Could not read 5ea878796f0a1d9649fe43a6a09df53d3915c0ef
> remote: fatal: revision walk setup failed
> remote: aborting due to possible repository corruption on the remote side.
> fatal: protocol error: bad pack header

I'm not sure what this could be related. Can you fetch from other trees,
e.g. your origin remote? Do you get the same error from the remote on
vihersipuli, and by using http instead?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
