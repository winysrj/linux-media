Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34022 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdAaUfW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 15:35:22 -0500
Date: Tue, 31 Jan 2017 20:33:40 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 20/24] media: imx: Add Camera Interface subdev driver
Message-ID: <20170131203340.GC27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-21-git-send-email-steve_longerbeam@mentor.com>
 <b7456d40-040d-41b7-45bc-ef6709ab7933@xs4all.nl>
 <20170131134252.GX27312@n2100.armlinux.org.uk>
 <b0517394-7717-3e1d-b850-e2b69a9c19e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0517394-7717-3e1d-b850-e2b69a9c19e9@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2017 at 10:21:26AM -0800, Steve Longerbeam wrote:
> On 01/31/2017 05:42 AM, Russell King - ARM Linux wrote:
> >On Fri, Jan 20, 2017 at 03:38:28PM +0100, Hans Verkuil wrote:
> >>Should be set to something like 'platform:imx-media-camif'. v4l2-compliance
> >>should complain about this.
> >... and more.
> 
> Right, in version 3 that you are working with, no v4l2-compliance fixes were
> in yet. A lot of the compliance errors are fixed, please look in latest
> branch
> imx-media-staging-md-wip at git@github.com:slongerbeam/mediatree.git.

Sorry, I'm not prepared to pull random trees from github as there's
no easy way to see what's in the branch.

I've always disliked github because its web interface makes it soo
difficult to navigate around git trees hosted there.  You can see
a commit, you can see a diff of the commit.  You can get a list of
branches.  But there seems to be no way to get a list of commits
similar to "git log" or even a one-line summary of each commit on
a branch.  If there is, it's completely non-obvious (which I think is
much of the problem with github, it's web interface is horrendous.)

Or you can clone/pull the tree without knowing what you're fetching
(eg, what the tree is based upon.)

Or you can waste time clicking repeatedly on the "parent" commit link
on each patch working your way back through the history...

Well, it looks like it's bsaed on 4.10-rc1 with who-knows-what work
from the linux-media tree (I didn't try and go back any further.)
As I don't want to take a whole pile of other changes into my tree,
I'm certainly not going to pull from your github tree.  Sorry.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
