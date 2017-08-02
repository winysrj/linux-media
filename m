Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36873 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdHBTSW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 15:18:22 -0400
Date: Wed, 2 Aug 2017 21:18:17 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..."
        <linux-samsung-soc@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH for v4.13] ARM: dts: exynos: add needs-hpd for
 Odroid-XU3/4
Message-ID: <20170802191817.qwue5uisiszlcc6m@kozik-lap>
References: <89e9a925-66a9-8c26-559c-1b1f0e8070e3@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <89e9a925-66a9-8c26-559c-1b1f0e8070e3@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 31, 2017 at 01:56:42PM +0200, Hans Verkuil wrote:
> CEC support was added for Exynos5 in 4.13, but for the Odroids we need to set
> 'needs-hpd' as well since CEC is disabled when there is no HDMI hotplug signal,
> just as for the exynos4 Odroid-U3.
> 
> This is due to the level-shifter that is disabled when there is no HPD, thus
> blocking the CEC signal as well. Same close-but-no-cigar board design as the
> Odroid-U3.
> 
> Tested with my Odroid XU4.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks, applied for v4.13.

Best regards,
Krzysztof
