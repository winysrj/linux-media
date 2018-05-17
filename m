Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34348 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750924AbeEQLan (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 07:30:43 -0400
Date: Thu, 17 May 2018 14:30:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Daniel Mack <daniel@zonque.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180517113041.rna6yksrgyfqtlgi@valkosipuli.retiisi.org.uk>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <645869ce-3cad-29e9-72ed-297a9e787c48@zonque.org>
 <20180517112207.lrcif2qwpkbiy2zs@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517112207.lrcif2qwpkbiy2zs@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 17, 2018 at 01:22:07PM +0200, Maxime Ripard wrote:
> Hi,
> 
> On Thu, May 17, 2018 at 11:24:04AM +0200, Daniel Mack wrote:
> > Hi,
> > 
> > On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
> > > Here is a "small" series that mostly cleans up the ov5640 driver code,
> > > slowly getting rid of the big data array for more understandable code
> > > (hopefully).
> > > 
> > > The biggest addition would be the clock rate computation at runtime,
> > > instead of relying on those arrays to setup the clock tree
> > > properly. As a side effect, it fixes the framerate that was off by
> > > around 10% on the smaller resolutions, and we now support 60fps.
> > > 
> > > This also introduces a bunch of new features.
> > 
> > I'd like to give this a try. What tree should this patch set be applied on?
> > I had no luck with media_tree/for-4.18-6.
> 
> Maybe it wasn't the latest after all, sorry. It's based on Sakari's
> for-4.18-3 PR (67f76c65e94f).

I've pushed these here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.18-5>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
