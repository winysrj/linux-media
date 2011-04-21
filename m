Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:62915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1DUOSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 10:18:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Thu, 21 Apr 2011 16:18:31 +0200
Cc: "'Joerg Roedel'" <joerg.roedel@amd.com>,
	linux-samsung-soc@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com> <201104211400.13289.arnd@arndb.de> <003301cc002c$f67ba0c0$e372e240$%szyprowski@samsung.com>
In-Reply-To: <003301cc002c$f67ba0c0$e372e240$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104211618.31418.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 21 April 2011, Marek Szyprowski wrote:
> > No, I think that would be much worse, it definitely destroys all kinds of
> > assumptions that the core code makes about devices. However, I don't think
> > it's much of a problem to just create two child devices and use them
> > from the main driver, you don't really need to create a device_driver
> > to bind to each of them.
> 
> I must have missed something. Video codec is a platform device and struct
> device pointer is gathered from it (&pdev->dev). How can I define child
> devices and attach them to the platform device?

There are a number of ways:

* Do device_create() with &pdev->dev as the parent, inside of the
  codec driver, with a new class you create for this purpose
* Do device_register() for a device, in the same way
* Create the additional platform devices in the platform code,
  with their parents pointing to the code device, then
  look for them using device_for_each_child in the driver
* Create two codec devices in parallel and bind to both with your
  driver, ideally splitting up the resources between the two
  devices in a meaningful way.

None of them are extremely nice, but it's not that hard either.
You should probably prototype a few of these approaches to see
which one is the least ugly one.

	Arnd
