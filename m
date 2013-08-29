Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33468 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3H2KOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 06:14:22 -0400
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
	m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
	swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
	mturquette@linaro.org, tomasz.figa@gmail.com,
	kgene.kim@samsung.com, thomas.abraham@linaro.org,
	s.nawrocki@samsung.com, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux@arm.linux.org.uk,
	ben-linux@fluff.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 1/6] media: s5p-tv: Replace mxr_ macro by default dev_
Date: Thu, 29 Aug 2013 12:14:16 +0200
Message-id: <1562143.sxFLZnf0g9@amdc1227>
In-reply-to: <1377706384-3697-2-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377706384-3697-2-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mateusz,

On Wednesday 28 of August 2013 18:12:59 Mateusz Krawczuk wrote:
> Replace mxr_dbg, mxr_info and mxr_warn by generic solution.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  drivers/media/platform/s5p-tv/mixer.h           |  12 ---
>  drivers/media/platform/s5p-tv/mixer_drv.c       |  47 ++++++-----
>  drivers/media/platform/s5p-tv/mixer_grp_layer.c |   2 +-
>  drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
>  drivers/media/platform/s5p-tv/mixer_video.c     | 100
> ++++++++++++------------ drivers/media/platform/s5p-tv/mixer_vp_layer.c 
> |   2 +-
>  6 files changed, 78 insertions(+), 91 deletions(-)

Although, this is a valid patch, I don't think it is related by any way to 
migration of S5PV210 to common clock framework. So, IMHO, this patch should 
be send separately, not as a part of this series.

Best regards,
Tomasz

