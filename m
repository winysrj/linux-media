Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53976 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933374AbdCaQfY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 12:35:24 -0400
Date: Fri, 31 Mar 2017 17:35:03 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Patrice.chotard@st.com
Subject: Re: [PATCHv6 00/10] video/exynos/sti/cec: add CEC notifier & use in
 drivers
Message-ID: <20170331163503.GA31779@n2100.armlinux.org.uk>
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
 <20170331143920.GU7909@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170331143920.GU7909@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 31, 2017 at 03:39:20PM +0100, Russell King - ARM Linux wrote:
> On Fri, Mar 31, 2017 at 02:20:26PM +0200, Hans Verkuil wrote:
> > Comments are welcome. I'd like to get this in for the 4.12 kernel as
> > this is a missing piece needed to integrate CEC drivers.
> 
> First two patches seem fine, and work with dw-hdmi.
> 
> I'll hold dw-hdmi off until after 4.11 - I currently have this stuff
> merged against 4.10, and there's some conflicts with 4.11.
> 
> I also wanted to say that tda998x/tda9950 works, and send you those
> patches, but while trying to test them this afternoon in a tree with
> some of the DRM code that was merged during the last merge window on
> a v4.10 based tree (which I need because of etnaviv), the kernel
> oopses in DRM for god-knows-why.  If/when I get this sorted (don't
> know when) I'll send that stuff as a follow-up to your series.

... and that's looking impossible - the next problem after that seems
to be that the rootfs drive for the box has failed, so I've currently
no way to test tda998x stuff until I get a new drive, filesystem and
so forth rebuilt.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
