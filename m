Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40922 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932377AbdC3Wfn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 18:35:43 -0400
Date: Thu, 30 Mar 2017 23:35:27 +0100
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
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 04/11] exynos_hdmi: add CEC notifier support
Message-ID: <20170330223527.GK7909@n2100.armlinux.org.uk>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
 <20170329141543.32935-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170329141543.32935-5-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 04:15:36PM +0200, Hans Verkuil wrote:
> +	cec_notifier_set_phys_addr(hdata->notifier,
> +				   cec_get_edid_phys_addr(edid));

This pattern causes problems - can we have the notifier taking the EDID
please, and stubs in cec-notifier.h to stub that out?

Maybe something like cec_notifier_set_phys_addr_from_edid(edid) ?

Having converted the tda998x code over to your new notifier, the 0-day
builder reported this tonight:

>> ERROR: "cec_get_edid_phys_addr" [drivers/gpu/drm/i2c/tda998x.ko] undefined!

which is caused exactly by this problem.  I can add #ifdefs into the
tda998x driver, but as you're already stubbing out
cec_notifier_set_phys_addr() in cec-notifier.h, it would be stupid to
have to resort to #ifdefs in driver code to solve this issue.

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
