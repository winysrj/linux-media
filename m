Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238Ab0FAUuH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 16:50:07 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o51Ko6vL019226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:50:07 -0400
Date: Tue, 1 Jun 2010 16:50:05 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] IR: add lirc support to ir-core
Message-ID: <20100601205005.GA28322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds the core lirc device interface, lirc_dev, and
an ir-core bridge driver. Currently, only the receive side is wired
up in the bridge driver, but adding transmit support is up next.

Currently, adding this code allows any raw IR ir-core device driver to
pass raw IR out to the lirc userspace, without the driver having to have
any actual knowledge of lirc -- its just feeding data to another IR
protocol decoder engine.

This also (hopefully) makes life easier for any currently out-of-tree
pure lirc device drivers, as they can count on the lirc core bits being
present. This is a Good Thing(tm) while we work on porting additional
lirc device drivers to ir-core, and also makes life easier for users to
migrate from lirc decoding to in-kernel decoding (where possible) when
their device's driver gets ported.

This patchset has been tested with the ir-core mceusb driver, and IR
receive behaves 100% identical in lirc mode to the old lirc_mceusb.

[PATCH 1/3] IR: add core lirc device interface
[PATCH 2/3] IR: add an empty lirc "protocol" keymap
[PATCH 3/3] IR: add ir-core to lirc interface bridge driver

-- 
Jarod Wilson
jarod@redhat.com

