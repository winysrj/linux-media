Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:52944 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1CNNc1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 09:32:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: KyongHo Cho <pullip.cho@samsung.com>
Subject: Re: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Mon, 14 Mar 2011 14:32:19 +0100
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	k.debski@samsung.com, kgene.kim@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	=?utf-8?q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
	=?utf-8?q?=EA=B0=95=EB=AF=BC=EA=B7=9C?= <mk7.kang@samsung.com>,
	linux-kernel@vger.kernel.org
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com> <201103111700.17373.arnd@arndb.de> <AANLkTimagS1vBXEYjXQDx=OGhTRm=n0yO4n+kHTAqBOz@mail.gmail.com>
In-Reply-To: <AANLkTimagS1vBXEYjXQDx=OGhTRm=n0yO4n+kHTAqBOz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103141432.19614.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 14 March 2011, KyongHo Cho wrote:
> I think we can consider another solution for the various requirements.
> I think one of the most possible solutions is VCMM.
> Or we can enhance include/linux/iommu.h with reference of VCMM.

I think extending or changing the existing interface would be much
preferred. It's always better to limit the number of interfaces
that do the same thing, and we already have more duplication than
we want with the two dma-mapping.h and iommu.h interfaces.

Note that any aspect of the existing interface can be changed if
necessary, as long as there is a way to migrate all the existing
users. Since the iommu API is not exported to user space, there
is no requirement to keep it stable.

	Arnd
