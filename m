Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22894 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502Ab3COQ2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 12:28:44 -0400
Date: Fri, 15 Mar 2013 09:28:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] ir: IR_RX51 only works on OMAP2
Message-ID: <20130315162837.GD9370@atomide.com>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
 <1363298204-8014-7-git-send-email-arnd@arndb.de>
 <20130315063913.GC1638@itanic.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315063913.GC1638@itanic.dhcp.inet.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Timo Kokkonen <timo.t.kokkonen@iki.fi> [130314 23:43]:
> On 03.14 2013 22:56:44, Arnd Bergmann wrote:
> > This driver can be enabled on OMAP1 at the moment, which breaks
> > allyesconfig for that platform. Let's mark it OMAP2PLUS-only
> > in Kconfig, since that is the only thing it builds on.
> > 
> 
> Acked-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>

Acked-by: Tony Lindgren <tony@atomide.com>
