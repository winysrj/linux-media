Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35731 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932604AbdEDJ00 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 05:26:26 -0400
Message-ID: <1493889978.2381.11.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/2] [media] platform: add video-multiplexer
 subdevice driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>, Pavel Machek <pavel@ucw.cz>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 04 May 2017 11:26:18 +0200
In-Reply-To: <20170504071703.GS7456@valkosipuli.retiisi.org.uk>
References: <20170502150913.2168-1-p.zabel@pengutronix.de>
         <20170502150913.2168-2-p.zabel@pengutronix.de>
         <20170503192836.GN7456@valkosipuli.retiisi.org.uk>
         <1493881652.2381.6.camel@pengutronix.de>
         <20170504071703.GS7456@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, 2017-05-04 at 10:17 +0300, Sakari Ailus wrote:
> Hi Philipp,
> 
> On Thu, May 04, 2017 at 09:07:32AM +0200, Philipp Zabel wrote:
> > On Wed, 2017-05-03 at 22:28 +0300, Sakari Ailus wrote:
> > > Hi Philipp,
> > > 
> > > Thanks for continuing working on this!
> > > 
> > > I have some minor comments below...
> > 
> > Thank you for the comments.
> > 
> > [...]
> > > Could you rebase this on the V4L2 fwnode patchset here, please?
> > > 
> > > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>
> > >
> > > The conversion is rather simple, as shown here:
> > > 
> > > <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=v4l2-acpi&id=679035e11bfdbea146fed5d52fb794b34dc9cea6>
> > 
> > What is the status of this patchset? Will this be merged soon?
> 
> I intend to send a pull request once the next rc1 tag is pulled on
> media-tree master. It depends on patches in linux-pm tree that aren't in
> media-tree yet.

I get conflicts trying to merge v4l2-acpi into v4.11 or media-tree
master. Could you provide an updated version?

regards
Philipp
