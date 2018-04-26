Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47236 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754077AbeDZIbg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 04:31:36 -0400
Date: Thu, 26 Apr 2018 11:31:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com,
        mchehab@kernel.org
Subject: Re: [PATCH 2/3] media: ov5640: add PIXEL_RATE and LINK_FREQ controls
Message-ID: <20180426083133.mcu6xo7usqspui7a@valkosipuli.retiisi.org.uk>
References: <20180420094419.11267-1-daniel@zonque.org>
 <20180420094419.11267-2-daniel@zonque.org>
 <20180424102222.ipzz754gou6kbdmk@valkosipuli.retiisi.org.uk>
 <abb6fbed-c325-7ca5-09f0-74b3a989c3f1@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abb6fbed-c325-7ca5-09f0-74b3a989c3f1@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 02:03:22PM +0200, Daniel Mack wrote:
> Hi,
> 
> On Tuesday, April 24, 2018 12:22 PM, Sakari Ailus wrote:
> > On Fri, Apr 20, 2018 at 11:44:18AM +0200, Daniel Mack wrote:
> >> Add v4l2 controls to report the pixel and MIPI link rates of each mode.
> >> The camss camera subsystem needs them to set up the correct hardware
> >> clocks.
> >>
> >> Tested on msm8016 based hardware.
> >>
> >> Signed-off-by: Daniel Mack <daniel@zonque.org>
> > 
> > Maxime has written a number of patches against the driver that seem very
> > much related; could you rebase these on his set (v2)?
> > 
> > <URL:https://patchwork.linuxtv.org/project/linux-media/list/?submitter=Maxime+Ripard&state=*&q=ov5640>
> 
> I didn't know about the ongoing work in this area, so I think both this
> and 3/3 are not needed. If you want, you can still pick the 1st patch in
> this series, but that's just a cosmetic cleanup.

That patch, too, would effectively need a rebase.

I'd also suggest adding a macro that constructs the entries in the array
--- much of what changes from entry to entry are fps, width, height and
whether subsampling or scaling has been used. That information would likely
fit nicely on a single line.

The resolution names are also redundant as the size is explicitly part of
the mode list variable names.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
