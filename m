Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34848 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbcE0XYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 19:24:48 -0400
MIME-Version: 1.0
In-Reply-To: <1464384685-347275-1-git-send-email-arnd@arndb.de>
References: <1464384685-347275-1-git-send-email-arnd@arndb.de>
Date: Fri, 27 May 2016 16:24:47 -0700
Message-ID: <CA+55aFw_SZ7nydXMQKcaQJmYy1=pCg7S6mUgHJGyfGvNoRgoRg@mail.gmail.com>
Subject: Re: [PATCH] remove lots of IS_ERR_VALUE abuses
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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

On Fri, May 27, 2016 at 2:23 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> This patch changes all users of IS_ERR_VALUE() that I could find
> on 32-bit ARM randconfig builds and x86 allmodconfig. For the
> moment, this doesn't change the definition of IS_ERR_VALUE()
> because there are probably still architecture specific users
> elsewhere.

Patch applied with the fixups from Al Viro edited in.

I also ended up removing a few other users (due to the vm_brk()
interface), and then made IS_ERR_VALUE() do the "void *" cast so that
integer use of a non-pointer size should now complain.

It works for me and has no new warnings in my allmodconfig build, and
with your ARM work that is presumably clean too. But other
architectures may see new warnings.

People who got affected by this should check their subsystem code for
the changes.

              Linus
