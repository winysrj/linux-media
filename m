Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35752 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab3BLOFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 09:05:08 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so86761wgb.32
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2013 06:05:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511A4442.6000402@samsung.com>
References: <1360128584-23167-1-git-send-email-sachin.kamat@linaro.org>
	<1360128584-23167-2-git-send-email-sachin.kamat@linaro.org>
	<CAAQKjZNmUVZnDcy3fbWkairnneOK7dooJT2gn=9++tzS=uhhzA@mail.gmail.com>
	<511A4442.6000402@samsung.com>
Date: Tue, 12 Feb 2013 22:57:41 +0900
Message-ID: <CAAQKjZMcmhb7djsSgRHFvVujq6TDTwDgkH=SzVVYOdegKa-tMQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] drm/exynos: Add device tree based discovery
 support for G2D
From: Inki Dae <inki.dae@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	kgene.kim@samsung.com, patches@linaro.org,
	devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/2/12 Sylwester Nawrocki <s.nawrocki@samsung.com>:
> On 02/12/2013 02:17 PM, Inki Dae wrote:
>> Applied and will go to -next.
>> And please post the document(in
>> Documentation/devicetree/bindings/gpu/) for it later.
>
> There is already some old patch applied in the devicetree/next tree:
>
> http://git.secretlab.ca/?p=linux.git;a=commitdiff;h=09495dda6a62c74b13412a63528093910ef80edd
>
> I guess there is now an incremental patch needed for this.
>

I think that this patch should be reverted because the compatible
string of this document isn't generic and also the document file
should be moved into proper place(.../bindings/gpu/).

So Mr. Grant, could you please revert the below patch?
        "of/exynos_g2d: Add Bindings for exynos G2D driver"
        commit: 09495dda6a62c74b13412a63528093910ef80edd

This document should be modifed correctly and re-posted. For this, we
have already reached an arrangement with other Exynos maintainters.

Thanks,
Inki Dae

>
> Regards,
> Sylwester
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
