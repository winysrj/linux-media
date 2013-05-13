Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:64790 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab3EMJlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:41:13 -0400
Message-ID: <1368438071.1350.43.camel@x61.thuisdomein>
Subject: Re: [v3] media: davinci: kconfig: fix incorrect selects
From: Paul Bolle <pebolle@tiscali.nl>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Date: Mon, 13 May 2013 11:41:11 +0200
In-Reply-To: <1363079692-16683-1-git-send-email-nsekhar@ti.com>
References: <1363079692-16683-1-git-send-email-nsekhar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2013-03-12 at 09:14 +0000, Sekhar Nori wrote:
> drivers/media/platform/davinci/Kconfig uses selects where
> it should be using 'depends on'. This results in warnings of
> the following sort when doing randconfig builds.
> 
> warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
> 
> The VPIF kconfigs had a strange 'select' and 'depends on' cross
> linkage which have been fixed as well by removing unneeded
> VIDEO_DAVINCI_VPIF config symbol.
> 
> Similarly, remove the unnecessary VIDEO_VPSS_SYSTEM and
> VIDEO_VPFE_CAPTURE. They don't select any independent functionality
> and were being used to manage code dependencies which can
> be handled using makefile.
> 
> Selecting video modules is now dependent on all ARCH_DAVINCI
> instead of specific EVMs and SoCs earlier. This should help build
> coverage. Remove unnecessary 'default y' for some config symbols.
> 
> While at it, fix the Kconfig help text to make it more readable
> and fix names of modules created during module build.
> 
> Rename VIDEO_ISIF to VIDEO_DM365_ISIF as per suggestion from
> Prabhakar.
> 
> This patch has only been build tested; I have tried to not break
> any existing assumptions. I do not have the setup to test video,
> so any test reports welcome.
> 
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This seems to be the patch that ended up as mainline commit
3778d05036cc7ddd983ae2451da579af00acdac2 (which was included in
v3.10-rc1).

After that commit there's still one reference to VIDEO_VPFE_CAPTURE in
the tree: as a (negative) dependency in
drivers/staging/media/davinci_vpfe/Kconfig. Can that (negative)
dependency now be dropped (as it's currently useless) or should it be
replaced with a (negative) dependency on a related symbol?


Paul Bolle

