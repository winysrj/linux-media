Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0GCEFb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 00:05:31 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6345V94004805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:05:31 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6345USM017458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:05:30 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o6345UjY031477
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:05:30 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o6345UjL031475
	for linux-media@vger.kernel.org; Sat, 3 Jul 2010 00:05:30 -0400
Date: Sat, 3 Jul 2010 00:05:30 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 0/3] IR: add lirc support to ir-core
Message-ID: <20100703040530.GB31255@redhat.com>
References: <20100601205005.GA28322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601205005.GA28322@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 01, 2010 at 04:50:05PM -0400, Jarod Wilson wrote:
> This patch series adds the core lirc device interface, lirc_dev, and
> an ir-core bridge driver. Currently, only the receive side is wired
> up in the bridge driver, but adding transmit support is up next.
> 
> Currently, adding this code allows any raw IR ir-core device driver to
> pass raw IR out to the lirc userspace, without the driver having to have
> any actual knowledge of lirc -- its just feeding data to another IR
> protocol decoder engine.
> 
> This also (hopefully) makes life easier for any currently out-of-tree
> pure lirc device drivers, as they can count on the lirc core bits being
> present. This is a Good Thing(tm) while we work on porting additional
> lirc device drivers to ir-core, and also makes life easier for users to
> migrate from lirc decoding to in-kernel decoding (where possible) when
> their device's driver gets ported.
> 
> This patchset has been tested with the ir-core mceusb driver, and IR
> receive behaves 100% identical in lirc mode to the old lirc_mceusb.
> 
> [PATCH 1/3] IR: add core lirc device interface
> [PATCH 2/3] IR: add an empty lirc "protocol" keymap
> [PATCH 3/3] IR: add ir-core to lirc interface bridge driver

Version 2 moves a good chunk of ir tx details that are (probably) specific
to providing raw IR data from userspace via lirc into the ir-core lirc
bridge driver, instead of having them in the hardware-specific drivers
themselves. This greatly reduced the complexity of the mceusb driver's ir
tx function, and generalized the tx interface better for a non-lirc tx
implementation.

-- 
Jarod Wilson
jarod@redhat.com

