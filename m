Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3ACQd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 11:33:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 133/493] remove use of __devexit_p
Date: Thu, 3 Jan 2013 16:33:24 +0000
Cc: Bill Pemberton <wfp5p@virginia.edu>, gregkh@linuxfoundation.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	David =?utf-8?q?H=C3=A4rdeman?= <david@hardeman.nu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	mjpeg-users@lists.sourceforge.net,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu> <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301031633.24214.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 19 November 2012, Bill Pemberton wrote:
> CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
> needed.

I've seen a few cases where __devexit was incorrectly paired with __exit_p().
Have you checked for those as well? It may be worth removing those at the
same time.

	Arnd
