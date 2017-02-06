Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20333 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbdBFNIP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 08:08:15 -0500
Subject: Re: [PATCHv4 1/9] video: add hotplug detect notifier support
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <dff7e731-8e73-a4c6-c338-fa58bd4f4aa9@samsung.com>
Date: Mon, 06 Feb 2017 14:08:09 +0100
MIME-version: 1.0
In-reply-to: <20170206102951.12623-2-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
 <CGME20170206103035epcas1p27ddfca1de4b572a8565bb8b3b1b2de24@epcas1p2.samsung.com>
 <20170206102951.12623-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.02.2017 11:29, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Add support for video hotplug detect and EDID/ELD notifiers, which is used
> to convey information from video drivers to their CEC and audio counterparts.
>
> Based on an earlier version from Russell King:
>
> https://patchwork.kernel.org/patch/9277043/
>
> The hpd_notifier is a reference counted object containing the HPD/EDID/ELD state
> of a video device.
>
> When a new notifier is registered the current state will be reported to
> that notifier at registration time.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

For patches 1-6:
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
--
Regards
Andrzej


