Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3DKKwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 06:52:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 11/30] [media] exynos: remove unnecessary header inclusions
Date: Thu, 11 Apr 2013 12:52:03 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Kukjin Kim <kgene.kim@samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <20130410211354.397d5689@redhat.com> <51667D3D.20103@samsung.com>
In-Reply-To: <51667D3D.20103@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111252.04023.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 April 2013, Sylwester Nawrocki wrote:
> On 04/11/2013 02:13 AM, Mauro Carvalho Chehab wrote:
> > Em Thu, 11 Apr 2013 02:04:53 +0200
> > Arnd Bergmann <arnd@arndb.de> escreveu:
> > 
> >> In multiplatform configurations, we cannot include headers
> >> provided by only the exynos platform. Fortunately a number
> >> of drivers that include those headers do not actually need
> >> them, so we can just remove the inclusions.
> >>
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >> Cc: linux-media@vger.kernel.org
> >> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> This patch is already queued in the media tree for 3.10, and it can
> be found in -next now.
> 

Ok, thanks! I'll drop it from my series then.

	Arnd
