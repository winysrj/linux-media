Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:37094 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751795AbZAKXyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 18:54:12 -0500
From: David Brownell <david-b@pacbell.net>
To: hvaibhav@ti.com
Subject: Re: [REVIEW PATCH 2/2] Added OMAP3EVM Multi-Media Daughter Card Support
Date: Sun, 11 Jan 2009 15:54:10 -0800
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	video4linux-list@redhat.com, Brijesh Jadav <brijesh.j@ti.com>,
	Hardik Shah <hardik.shah@ti.com>, Manjunath Hadli <mrh@ti.com>,
	R Sivaraj <sivaraj@ti.com>
References: <hvaibhav@ti.com> <1231308470-31159-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1231308470-31159-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901111554.10469.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 06 January 2009, hvaibhav@ti.com wrote:
> +config MACH_OMAP3EVM_DC
> +       bool "OMAP 3530 EVM daughter card board"
> +       depends on ARCH_OMAP3 && ARCH_OMAP34XX && MACH_OMAP3EVM

There can be other daughtercards, so the Kconfig text should
say which specific card is being configured.  And it should
probably use the "zero or one of these choices" syntax, so
it's easier to include other options..

- Dave


