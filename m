Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41921 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbbF2Kn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:43:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux-samsung-soc@vger.kernel.org, kamil@wypas.org
Subject: [PATCH 0/4] cec-ctl/compliance: new CEC utilities
Date: Mon, 29 Jun 2015 12:43:12 +0200
Message-Id: <1435574596-38029-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds two new utilities to the v4l-utils git repository
(http://git.linuxtv.org/cgit.cgi/v4l-utils.git/). It assumes that the new
CEC framework available in the kernel:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg90085.html

The first patch adds the new cec headers to the 'sync-with-kernel' target,
the second syncs with the kernel and adds the new cec headers to v4l-utils,
the third adds the compliance utility and the last adds the cec-ctl utility.

The cec-compliance utility is by no means 100% coverage, in particular the
event API and non-blocking ioctls are untested. But it is a starting point,
and a complex protocol like CEC really needs a compliance tool.

The cec-ctl utility has almost full CEC message coverage: all generated from
the cec headers, so this is easy to keep up to date.

The main missing feature is that there is no logging of received messages.
This would be very useful to add. There is also no event handling/async message
handling yet.

But it is very useful to test CEC messages.

Regards,

	Hans

Hans Verkuil (4):
  Makefile.am: copy cec headers with make sync-with-kernel
  sync-with-kernel
  cec-compliance: add new CEC compliance utility
  cec-ctl: CEC control utility

 Makefile.am                                      |    4 +
 configure.ac                                     |    2 +
 contrib/freebsd/include/linux/input.h            |   13 +
 include/linux/cec-funcs.h                        | 1516 ++++++++++++++++++++++
 include/linux/cec.h                              |  709 ++++++++++
 utils/Makefile.am                                |    2 +
 utils/cec-compliance/Makefile.am                 |    3 +
 utils/cec-compliance/cec-compliance.cpp          |  943 ++++++++++++++
 utils/cec-compliance/cec-compliance.h            |   87 ++
 utils/cec-ctl/Makefile.am                        |    8 +
 utils/cec-ctl/cec-ctl.cpp                        | 1000 ++++++++++++++
 utils/cec-ctl/msg2ctl.pl                         |  330 +++++
 utils/keytable/parse.h                           |   10 +
 utils/keytable/rc_keymaps/cec                    |   77 ++
 utils/keytable/rc_keymaps/technisat_ts35         |   34 +
 utils/keytable/rc_keymaps/terratec_cinergy_c_pci |   49 +
 utils/keytable/rc_keymaps/terratec_cinergy_s2_hd |   49 +
 utils/keytable/rc_keymaps/twinhan_dtv_cab_ci     |   54 +
 utils/keytable/rc_maps.cfg                       |    1 +
 19 files changed, 4891 insertions(+)
 create mode 100644 include/linux/cec-funcs.h
 create mode 100644 include/linux/cec.h
 create mode 100644 utils/cec-compliance/Makefile.am
 create mode 100644 utils/cec-compliance/cec-compliance.cpp
 create mode 100644 utils/cec-compliance/cec-compliance.h
 create mode 100644 utils/cec-ctl/Makefile.am
 create mode 100644 utils/cec-ctl/cec-ctl.cpp
 create mode 100755 utils/cec-ctl/msg2ctl.pl
 create mode 100644 utils/keytable/rc_keymaps/cec
 create mode 100644 utils/keytable/rc_keymaps/technisat_ts35
 create mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_c_pci
 create mode 100644 utils/keytable/rc_keymaps/terratec_cinergy_s2_hd
 create mode 100644 utils/keytable/rc_keymaps/twinhan_dtv_cab_ci

-- 
2.1.4

