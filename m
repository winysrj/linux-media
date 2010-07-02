Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab0GBDhE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jul 2010 23:37:04 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o623b3r8030608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 23:37:04 -0400
Date: Thu, 1 Jul 2010 23:37:02 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 0/2] IR: add initial IR transmit support
Message-ID: <20100702033702.GA27368@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To enable IR transmit support in the mceusb driver, I need to add just
three callbacks to achieve feature-parity with IR transmit using the old
lirc_mceusb driver. This series adds those callbacks to ir-core's
ir_dev_props struct, then wires them up for the mceusb driver.

At the moment, we have no "native" interface for transmitting IR, but a
later patchset to add "legacy" lirc device interface support provides a
means to transmit IR using this ir-core implementation.

[PATCH 1/2] IR: add tx callbacks to ir-core
[PATCH 2/2] IR/mceusb: add and wire up tx callback functions

Patches are against the linuxtv staging/rc tree, but will probably apply
elsewhere as well.

v2: the mceusb driver no longer makes a copy_from_user() call to pull in
its tx data buffer, it will be provided by whatever is providing the tx
data, be that an in-kernel IR encoder or a forthcoming lirc bridge driver
plugin, which gets *its* data from userspace using copy_from_user().

-- 
Jarod Wilson
jarod@redhat.com

