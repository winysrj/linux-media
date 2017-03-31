Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:38330 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932846AbdCaIFd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 04:05:33 -0400
Subject: Re: [PATCHv5 04/11] exynos_hdmi: add CEC notifier support
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
 <20170329141543.32935-5-hverkuil@xs4all.nl>
 <20170330223527.GK7909@n2100.armlinux.org.uk>
Cc: linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b4c6a816-fd67-35f2-c740-6abf77d5d9b6@xs4all.nl>
Date: Fri, 31 Mar 2017 10:05:25 +0200
MIME-Version: 1.0
In-Reply-To: <20170330223527.GK7909@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/03/17 00:35, Russell King - ARM Linux wrote:
> On Wed, Mar 29, 2017 at 04:15:36PM +0200, Hans Verkuil wrote:
>> +	cec_notifier_set_phys_addr(hdata->notifier,
>> +				   cec_get_edid_phys_addr(edid));
> 
> This pattern causes problems - can we have the notifier taking the EDID
> please, and stubs in cec-notifier.h to stub that out?
> 
> Maybe something like cec_notifier_set_phys_addr_from_edid(edid) ?

Good point. I've added this, and as an extra bonus this allowed me to drop
the first cec-edid patch.

> 
> Having converted the tda998x code over to your new notifier, the 0-day
> builder reported this tonight:
> 
>>> ERROR: "cec_get_edid_phys_addr" [drivers/gpu/drm/i2c/tda998x.ko] undefined!
> 
> which is caused exactly by this problem.  I can add #ifdefs into the
> tda998x driver, but as you're already stubbing out
> cec_notifier_set_phys_addr() in cec-notifier.h, it would be stupid to
> have to resort to #ifdefs in driver code to solve this issue.

Will post a new series today. Thanks for pointing this out.

A general note: I am considering merging cec-notifier and cec-edid into the
CEC module itself. However, I want to get this series in first before I start
moving things around. It's been delayed long enough already.

Regards,

	Hans
