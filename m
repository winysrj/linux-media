Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbcE0VqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 17:46:07 -0400
Date: Fri, 27 May 2016 14:46:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrzej Hajda <a.hajda@samsung.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	David Airlie <airlied@linux.ie>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Russell King <linux@armlinux.org.uk>,
	Bob Peterson <rpeterso@redhat.com>, linux-acpi@vger.kernel.org,
	iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH] remove lots of IS_ERR_VALUE abuses
Message-Id: <20160527144605.f2a52ea02cad1297ff188691@linux-foundation.org>
In-Reply-To: <1464384685-347275-1-git-send-email-arnd@arndb.de>
References: <1464384685-347275-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 May 2016 23:23:25 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> Most users of IS_ERR_VALUE() in the kernel are wrong, as they
> pass an 'int' into a function that takes an 'unsigned long'
> argument. This happens to work because the type is sign-extended
> on 64-bit architectures before it gets converted into an
> unsigned type.
> 
> However, anything that passes an 'unsigned short' or 'unsigned int'
> argument into IS_ERR_VALUE() is guaranteed to be broken, as are
> 8-bit integers and types that are wider than 'unsigned long'.
> 
> Andrzej Hajda has already fixed a lot of the worst abusers that
> were causing actual bugs, but it would be nice to prevent any
> users that are not passing 'unsigned long' arguments.
> 
> This patch changes all users of IS_ERR_VALUE() that I could find
> on 32-bit ARM randconfig builds and x86 allmodconfig. For the
> moment, this doesn't change the definition of IS_ERR_VALUE()
> because there are probably still architecture specific users
> elsewhere.

So you do plan to add some sort of typechecking into IS_ERR_VALUE()?

> Almost all the warnings I got are for files that are better off
> using 'if (err)' or 'if (err < 0)'.
> The only legitimate user I could find that we get a warning for
> is the (32-bit only) freescale fman driver, so I did not remove
> the IS_ERR_VALUE() there but changed the type to 'unsigned long'.
> For 9pfs, I just worked around one user whose calling conventions
> are so obscure that I did not dare change the behavior.
> 
> I was using this definition for testing:
> 
>  #define IS_ERR_VALUE(x) ((unsigned long*)NULL == (typeof (x)*)NULL && \
>        unlikely((unsigned long long)(x) >= (unsigned long long)(typeof(x))-MAX_ERRNO))
> 
> which ends up making all 16-bit or wider types work correctly with
> the most plausible interpretation of what IS_ERR_VALUE() was supposed
> to return according to its users, but also causes a compile-time
> warning for any users that do not pass an 'unsigned long' argument.
> 
> I suggested this approach earlier this year, but back then we ended
> up deciding to just fix the users that are obviously broken. After
> the initial warning that caused me to get involved in the discussion
> (fs/gfs2/dir.c) showed up again in the mainline kernel, Linus
> asked me to send the whole thing again.
