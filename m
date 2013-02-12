Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53319 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab3BLNbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 08:31:50 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MI40025G06WAO60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 12 Feb 2013 13:31:47 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MI400CLG08YHO30@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 12 Feb 2013 13:31:47 +0000 (GMT)
Message-id: <511A4442.6000402@samsung.com>
Date: Tue, 12 Feb 2013 14:31:46 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Inki Dae <inki.dae@samsung.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	patches@linaro.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 2/2] drm/exynos: Add device tree based discovery support
 for G2D
References: <1360128584-23167-1-git-send-email-sachin.kamat@linaro.org>
 <1360128584-23167-2-git-send-email-sachin.kamat@linaro.org>
 <CAAQKjZNmUVZnDcy3fbWkairnneOK7dooJT2gn=9++tzS=uhhzA@mail.gmail.com>
In-reply-to: <CAAQKjZNmUVZnDcy3fbWkairnneOK7dooJT2gn=9++tzS=uhhzA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2013 02:17 PM, Inki Dae wrote:
> Applied and will go to -next.
> And please post the document(in
> Documentation/devicetree/bindings/gpu/) for it later.

There is already some old patch applied in the devicetree/next tree:

http://git.secretlab.ca/?p=linux.git;a=commitdiff;h=09495dda6a62c74b13412a63528093910ef80edd

I guess there is now an incremental patch needed for this.


Regards,
Sylwester

























