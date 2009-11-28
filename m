Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZK1KnV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 05:43:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Date: Sat, 28 Nov 2009 11:43:18 +0100
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
References: <4B0A765F.7010204@redhat.com> <20091128025437.GN6936@core.coreip.homeip.net> <4B10F0BC.60008@redhat.com>
In-Reply-To: <4B10F0BC.60008@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911281143.18418.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 28 November 2009, Mauro Carvalho Chehab wrote:
> After deleting 49 keys, you'll need to add the 55 new keys.
> If we do dynamic table resize for each operation, we'll do 104 
> sequences of kmalloc/kfree for replacing one table. 

Given that kmalloc only does power-of-two allocations, you can limit
the resize operations to when you go beyond the current allocation
limit. You can also choose a reasonable minimum table size (e.g. 32
or 64 entries) and avoid resizes for many of the common cases entirely.

	Arnd <><
