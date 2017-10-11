Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42354 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdJKXGs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 19:06:48 -0400
Date: Thu, 12 Oct 2017 00:06:33 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH] media: staging/imx: do not return error in link_notify
 for unknown sources
Message-ID: <20171011230633.GZ20805@n2100.armlinux.org.uk>
References: <1507057753-31808-1-git-send-email-steve_longerbeam@mentor.com>
 <20171011214906.GX20805@n2100.armlinux.org.uk>
 <87b48a34-4beb-eb21-3361-28f6edb6d73c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87b48a34-4beb-eb21-3361-28f6edb6d73c@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 11, 2017 at 03:14:26PM -0700, Steve Longerbeam wrote:
> 
> 
> On 10/11/2017 02:49 PM, Russell King - ARM Linux wrote:
> >On Tue, Oct 03, 2017 at 12:09:13PM -0700, Steve Longerbeam wrote:
> >>imx_media_link_notify() should not return error if the source subdevice
> >>is not recognized by imx-media, that isn't an error. If the subdev has
> >>controls they will be inherited starting from a known subdev.
> >What does "a known subdev" mean?
> 
> It refers to the previous sentence, "not recognized by imx-media". A
> subdev that was not registered via async registration and so not in
> imx-media's async subdev list. I could elaborate in the commit message
> but it seems fairly obvious to me.

I don't think it's obvious, and I suspect you won't think it's obvious
in years to come (I talk from experience of some commentry I've added
in the past.)

Now, isn't it true that for a subdev to be part of a media device, it
has to be registered, and if it's part of a media device that is made
up of lots of different drivers, it has to use the async registration
code?  So, is it not also true that any subdev that is part of a
media device, it will be "known"?

Under what circumstances could a subdev be part of a media device but
not be "known" ?

Now, if you mean "known" to be equivalent with "recognised by
imx-media" then, as I've pointed out several times already, that
statement is FALSE.  I'm not sure how many times I'm going to have to
state this fact.  Let me re-iterate again.  On my imx219 driver, I
have two subdevs.  Both subdevs have controls attached.  The pixel
subdev is not "recognised" by imx-media, and without a modification
like my or your patch, it fails.  However, with the modification,
this "unrecognised" subdev _STILL_ has it's controls visible through
imx-media.

Hence, I believe your comment in the code and your commit message
are misleading and wrong.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
