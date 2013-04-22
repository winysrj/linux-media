Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:16876 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3DVMaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:30:22 -0400
From: Tomasz Figa <t.figa@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: dri-devel@lists.freedesktop.org,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	linux-samsung-soc@vger.kernel.org,
	"patches@linaro.org" <patches@linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	linaro-kernel@lists.linaro.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	mturquette@linaro.org
Subject: Re: [PATCH v4] drm/exynos: prepare FIMD clocks
Date: Mon, 22 Apr 2013 14:30:10 +0200
Message-id: <1939043.4I27nO6WDE@amdc1227>
In-reply-to: <51750B7D.3050401@samsung.com>
References: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org>
 <1731019.P1JXV7Hkkn@amdc1227> <51750B7D.3050401@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 of April 2013 12:05:49 Sylwester Nawrocki wrote:
> On 04/22/2013 11:56 AM, Tomasz Figa wrote:
> > On Monday 22 of April 2013 10:44:00 Viresh Kumar wrote:
> >> On 21 April 2013 20:13, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> >>> 3) after those two changes, all that remains is to fix compliance with
> >>> Common Clock Framework, in other words:
> >>> 
> >>> s/clk_enable/clk_prepare_enable/
> >>> 
> >>> and
> >>> 
> >>> s/clk_disable/clk_disable_unprepare/
> >> 
> >> We don't have to call  clk_{un}prepare() everytime for your platform as
> >> you aren't doing anything in it. So just call them once at probe/remove
> >> and
> >> call clk_enable/disable everywhere else.
> 
> Yes, I agree with that. Additionally clk_(un)prepare must not be called in
> atomic context, so some drivers will have to work like this anyway.
> Or the clocks could be prepared/unprepared in the device open/close file op
> for instance.

Well, I don't think drivers should make any assumptions how particular clk ops 
are implemented on particular platform.

Instead, generic semantics of Common Clock Framework should be obeyed, which 
AFAIK are:
1) Each clock must be prepared before enabling.
2) clk_prepare() can not be called from atomic contexts.
3) clk_prepare_enable() can be used instead of clk_prepare() + clk_enable() 
when the driver does not need to enable the clock from atomic context.

Since the Exynos DRM FIMD driver does not need to do call any clock operations 
in atomic contexts, the approach keeping the clock handling as simple as 
possible would be to just replace all clk_{enable,disable} with 
clk_{prepare_enable,disable_unprepare}, as I suggested.

CCing Mike, the maintainer of Common Clock Framework, since he's the right 
person to pass any judgements when it is about clocks.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Kernel and System Framework

