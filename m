Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40256 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab3DVJ40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 05:56:26 -0400
From: Tomasz Figa <t.figa@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	linux-samsung-soc@vger.kernel.org,
	"patches@linaro.org" <patches@linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	linaro-kernel@lists.linaro.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4] drm/exynos: prepare FIMD clocks
Date: Mon, 22 Apr 2013 11:56:18 +0200
Message-id: <1731019.P1JXV7Hkkn@amdc1227>
In-reply-to: <CAKohpok+tNxCmy-TMRweObPLSVHECZzdgJxRh2iDWyXQCiJuqg@mail.gmail.com>
References: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org>
 <3109033.iP2qIPD33v@flatron>
 <CAKohpok+tNxCmy-TMRweObPLSVHECZzdgJxRh2iDWyXQCiJuqg@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 of April 2013 10:44:00 Viresh Kumar wrote:
> On 21 April 2013 20:13, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> > 3) after those two changes, all that remains is to fix compliance with
> > Common Clock Framework, in other words:
> > 
> > s/clk_enable/clk_prepare_enable/
> > 
> > and
> > 
> > s/clk_disable/clk_disable_unprepare/
> 
> We don't have to call  clk_{un}prepare() everytime for your platform as
> you aren't doing anything in it. So just call them once at probe/remove and
> call clk_enable/disable everywhere else.

Can you assure that in future SoCs, on which this driver will be used, this 
assumption will still hold true or even that in current Exynos driver this 
behavior won't be changed?

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Kernel and System Framework

