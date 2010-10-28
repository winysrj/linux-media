Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:43536 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0J1TII (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 15:08:08 -0400
Date: Thu, 28 Oct 2010 13:08:06 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] via-camera: fix OLPC serial port check
Message-ID: <20101028130806.66bd5b91@bike.lwn.net>
In-Reply-To: <20101027190228.3C87D9D401B@zog.reactivated.net>
References: <20101027190228.3C87D9D401B@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 27 Oct 2010 20:02:28 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> CONFIG_OLPC_XO_1_5 does not exist in mainline, and it's not certain that
> we'll find a reason to add it later.
> 
> We should also be detecting this at runtime, and if we do it at probe
> time we can be sure not to mess around with the PCI config space on XO-1.

This makes every user carry a bit of OLPC-specific code.  But there are
no non-OLPC users currently, the code is small, and we get rid of some
#ifdefs, which is always a good thing.  Seems good to me.

	Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
