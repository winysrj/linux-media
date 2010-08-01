Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0HACzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 22:55:08 -0400
Date: Sat, 31 Jul 2010 23:54:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Patrick Boettcher <patrick.boettcher@desy.de>,
	Luca Olivetti <luca@ventoso.org>,
	Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Aapo Tahkola <aet@rasterburn.org>,
	Chris Pascoe <c.pascoe@itee.uq.edu.au>
Subject: [PATCH 0/7] Port dvb-usb to ir-core
Message-ID: <20100731235409.7ce7b9df@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series starts the proccess of moving dvb-usb drivers to use
the new Remote Controller core. It adds support for rc-core at dvb-usb
core, while keeping support for the legacy mode.

One driver (dib0700) were ported to the new rc-core mode, as an example
for the low-level driver maintainers to port their drivers.

There are still some space for improvements on this port, like breaking
the dib0700 table into smaller ones, implementing protocol switch via
rc-core API, etc.

Ah, the first patch on this series fixes a problem caused on a
previous commit.

Mauro Carvalho Chehab (7):
  V4L/DVB: Partially revert commit da7251dd0bca6c17571be2bd4434b9779dea72d8
  V4L/DVB: dvb-usb: get rid of struct dvb_usb_rc_key
  V4L/DVB: dvb-usb: prepare drivers for using rc-core
  V4L/DVB: dvb-usb: add support for rc-core mode
  V4L/DVB: Add a keymap file with dib0700 table
  V4L/DVB: Port dib0700 to rc-core
  V4L/DVB: dib0700: avoid bad repeat

 drivers/media/IR/ir-sysfs.c                 |  155 ++++-----
 drivers/media/IR/keymaps/Makefile           |    1 +
 drivers/media/IR/keymaps/rc-dib0700-big.c   |  314 +++++++++++++++++
 drivers/media/dvb/dvb-usb/a800.c            |   12 +-
 drivers/media/dvb/dvb-usb/af9005-remote.c   |    4 +-
 drivers/media/dvb/dvb-usb/af9005.c          |   16 +-
 drivers/media/dvb/dvb-usb/af9005.h          |    2 +-
 drivers/media/dvb/dvb-usb/af9015.c          |   34 ++-
 drivers/media/dvb/dvb-usb/af9015.h          |   18 +-
 drivers/media/dvb/dvb-usb/anysee.c          |   18 +-
 drivers/media/dvb/dvb-usb/az6027.c          |   13 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c  |   12 +-
 drivers/media/dvb/dvb-usb/cxusb.c           |  128 ++++---
 drivers/media/dvb/dvb-usb/dib0700_core.c    |   87 +----
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  485 ++++++---------------------
 drivers/media/dvb/dvb-usb/dibusb-common.c   |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c       |   40 ++-
 drivers/media/dvb/dvb-usb/dibusb-mc.c       |   10 +-
 drivers/media/dvb/dvb-usb/dibusb.h          |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c          |   20 +-
 drivers/media/dvb/dvb-usb/dtt200u.c         |   42 ++-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c  |  198 ++++++++----
 drivers/media/dvb/dvb-usb/dvb-usb.h         |   90 ++++--
 drivers/media/dvb/dvb-usb/dw2102.c          |   67 ++--
 drivers/media/dvb/dvb-usb/m920x.c           |   44 ++-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c     |   14 +-
 drivers/media/dvb/dvb-usb/opera1.c          |   16 +-
 drivers/media/dvb/dvb-usb/vp702x.c          |   14 +-
 drivers/media/dvb/dvb-usb/vp7045.c          |   14 +-
 include/media/rc-map.h                      |    4 +
 30 files changed, 1026 insertions(+), 850 deletions(-)
 create mode 100644 drivers/media/IR/keymaps/rc-dib0700-big.c

