Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36786 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbcGSP5J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:57:09 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [RFC 0/7] Add support for IR transmitters
Date: Wed, 20 Jul 2016 00:56:51 +0900
Message-id: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is an RFCset that follows this patch:

http://marc.info/?l=linux-kernel&m=146736225606125&w=2

and after Sean's review and recommendations:

http://marc.info/?l=linux-kernel&m=146737935611128&w=2

The main goal is to add support in the rc framework for IR
transmitters, which currently is only supported by lirc but that
is not the preferred way.

with this RFCset I'm trying to gather some opinions as I'm not
really aware of other use cases other than the simple ir
transmitter in the last patch. As it is, the code to me looks
quite forced in order to achieve "my" goal by abusing on the
driver type check.

The last rfc-patch adds support for an IR transmitter driven by
the MOSI line of an SPI controller, it's the case of the Samsung
TM2(e) board which support is going to come soon.

Please let me know if there is anything to improve.

Thanks,
Andi

Andi Shyti (7):
  [media] rc-main: assign driver type during allocation
  [media] rc-main: split setup and unregister functions
  [media] rc-core: add support for IR raw transmitters
  [media] rc-ir-raw: do not generate any receiving thread for raw
    transmitters
  [media] ir-lirc-codec: do not handle any buffer for raw transmitters
  Documentation: bindings: add documentation for ir-spi device driver
  [media] rc: add support for IR LEDs driven through SPI

 Documentation/devicetree/bindings/media/spi-ir.txt |  20 +++
 drivers/media/rc/Kconfig                           |   9 ++
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/ir-lirc-codec.c                   |  30 ++--
 drivers/media/rc/ir-spi.c                          | 133 +++++++++++++++
 drivers/media/rc/rc-ir-raw.c                       |  17 +-
 drivers/media/rc/rc-main.c                         | 179 ++++++++++++---------
 include/media/rc-core.h                            |   3 +-
 8 files changed, 299 insertions(+), 93 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/spi-ir.txt
 create mode 100644 drivers/media/rc/ir-spi.c

-- 
2.8.1

