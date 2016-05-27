Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35023 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbcE0V4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 17:56:31 -0400
MIME-Version: 1.0
In-Reply-To: <20160527144605.f2a52ea02cad1297ff188691@linux-foundation.org>
References: <1464384685-347275-1-git-send-email-arnd@arndb.de>
	<20160527144605.f2a52ea02cad1297ff188691@linux-foundation.org>
Date: Fri, 27 May 2016 14:56:25 -0700
Message-ID: <CA+55aFwBcA9ViTxZ=bL=dP0CSWuLU7TY3OPpnYDjqbMsZY+fCQ@mail.gmail.com>
Subject: Re: [PATCH] remove lots of IS_ERR_VALUE abuses
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	David Airlie <airlied@linux.ie>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Russell King <linux@armlinux.org.uk>,
	Bob Peterson <rpeterso@redhat.com>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	"open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 27, 2016 at 2:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> So you do plan to add some sort of typechecking into IS_ERR_VALUE()?

The easiest way to do it is to just turn the (x) into (unsigned
long)(void *)(x), which then complains about casting an integer to a
pointer if the integer has the wrong size.

But if we get rid of the bogus cases, there's just a few left, and we
should probably just rename the whole thing (the initial double
underscore). It really isn't something normal people should use.

          Linus
