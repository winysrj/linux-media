Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:25754 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbcF1Ph3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 11:37:29 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id u5SFOxsj026872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 15:25:00 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [GIT PULL FOR v4.8] Two more CEC patches
Message-ID: <577296CA.8090101@cisco.com>
Date: Tue, 28 Jun 2016 17:24:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the missing rc-cec keymap module and a bug fix patch.

I originally thought the rc-cec module was already merged in the cec topic branch,
but I later discovered that it wasn't.

Regards,

	Hans

The following changes since commit c7169ad5616229b87cabf886bc5f9cbd1fc35a5f:

  [media] DocBook/media: add CEC documentation (2016-06-28 11:45:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-topic2

for you to fetch changes up to 4049cdd6d38815017c553a76c958181d11861133:

  cec-adap: on reply, restore the tx_status value from the transmit (2016-06-28 17:05:24 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      cec-adap: on reply, restore the tx_status value from the transmit

Kamil Debski (1):
      rc-cec: Add HDMI CEC keymap module

 drivers/media/rc/keymaps/Makefile    |   1 +
 drivers/media/rc/keymaps/rc-cec.c    | 182 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/cec/cec-adap.c |   1 +
 3 files changed, 184 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c
