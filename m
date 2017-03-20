Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34976 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754904AbdCTOgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:36:08 -0400
Date: Mon, 20 Mar 2017 14:27:28 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/4] video: add hotplug detect notifier support
Message-ID: <20170320142727.GA11521@n2100.armlinux.org.uk>
References: <1483366747-34288-1-git-send-email-hverkuil@xs4all.nl>
 <1483366747-34288-2-git-send-email-hverkuil@xs4all.nl>
 <20170320142616.GM21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170320142616.GM21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 02:26:16PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 02, 2017 at 03:19:04PM +0100, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Add support for video hotplug detect and EDID/ELD notifiers, which is used
> > to convey information from video drivers to their CEC and audio counterparts.
> > 
> > Based on an earlier version from Russell King:
> > 
> > https://patchwork.kernel.org/patch/9277043/
> > 
> > The hpd_notifier is a reference counted object containing the HPD/EDID/ELD state
> > of a video device.
> 
> I thought we had decided to drop the ELD bits?

Ignore that - mailer wrapped around to the first message in my mailbox!

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
