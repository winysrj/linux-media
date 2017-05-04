Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41156 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751742AbdEDJtU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 05:49:20 -0400
Date: Thu, 4 May 2017 12:48:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>, Pavel Machek <pavel@ucw.cz>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 2/2] [media] platform: add video-multiplexer subdevice
 driver
Message-ID: <20170504094845.GV7456@valkosipuli.retiisi.org.uk>
References: <20170502150913.2168-1-p.zabel@pengutronix.de>
 <20170502150913.2168-2-p.zabel@pengutronix.de>
 <20170503192836.GN7456@valkosipuli.retiisi.org.uk>
 <1493881652.2381.6.camel@pengutronix.de>
 <20170504071703.GS7456@valkosipuli.retiisi.org.uk>
 <1493889978.2381.11.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493889978.2381.11.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Thu, May 04, 2017 at 11:26:18AM +0200, Philipp Zabel wrote:
> Hi Sakari,
> 
> On Thu, 2017-05-04 at 10:17 +0300, Sakari Ailus wrote:
> > Hi Philipp,
> > 
> > On Thu, May 04, 2017 at 09:07:32AM +0200, Philipp Zabel wrote:
> > > On Wed, 2017-05-03 at 22:28 +0300, Sakari Ailus wrote:
> > > > Hi Philipp,
> > > > 
> > > > Thanks for continuing working on this!
> > > > 
> > > > I have some minor comments below...
> > > 
> > > Thank you for the comments.
> > > 
> > > [...]
> > > > Could you rebase this on the V4L2 fwnode patchset here, please?
> > > > 
> > > > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>
> > > >
> > > > The conversion is rather simple, as shown here:
> > > > 
> > > > <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=v4l2-acpi&id=679035e11bfdbea146fed5d52fb794b34dc9cea6>
> > > 
> > > What is the status of this patchset? Will this be merged soon?
> > 
> > I intend to send a pull request once the next rc1 tag is pulled on
> > media-tree master. It depends on patches in linux-pm tree that aren't in
> > media-tree yet.
> 
> I get conflicts trying to merge v4l2-acpi into v4.11 or media-tree
> master. Could you provide an updated version?

What kind of conflicts? I wonder if something somewhere is out of sync. :-)
My v4l2-acpi branch is on top of current media-tree master and appears to
merge cleanly to v4.11 as well.

It still wouldn't compile though as it depends on the fwnode graph patches.

I've merged those here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi-merge>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
