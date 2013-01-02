Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38544 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3ABJcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 04:32:00 -0500
Date: Wed, 2 Jan 2013 09:26:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Carpenter <error27@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sergei Shtylyov <sshtylyov@mvista.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of
	IS_ERR_OR_NULL
Message-ID: <20130102092638.GB2631@n2100.arm.linux.org.uk>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com> <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 02, 2013 at 08:10:36AM +0300, Dan Carpenter wrote:
> clk_get() returns NULL if CONFIG_HAVE_CLK is disabled.
> 
> I told Tony about this but everyone has been gone with end of year
> holidays so it hasn't been addressed.
> 
> Tony, please fix it so people don't apply these patches until
> clk_get() is updated to not return NULL.  It sucks to have to revert
> patches.

How about people stop using IS_ERR_OR_NULL for stuff which it shouldn't
be used for?
