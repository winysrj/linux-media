Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:39490 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751926AbdLQPky (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:40:54 -0500
Received: by mail-wm0-f51.google.com with SMTP id i11so25181864wmf.4
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:40:53 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 0/8] ddbridge improvements and cleanups
Date: Sun, 17 Dec 2017 16:40:41 +0100
Message-Id: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This series improves on a few things in ddbridge:

* Fix up a KASAN report which pops up with all TDA18212-equipped hardware
  by changing the order of all frontend driver teardown. This was
  originally thought to be a problem of the tda18212 driver, see
  https://patchwork.linuxtv.org/patch/45992/ (though other drivers with
  that problem may remain).
* Fix up CI resources cleanup handling, and further cosmetics and code
  move, all CI related
* Frontend cleanup improvements when handling errors (ie. when on one
  port the device initialisation fails). Whenever a tuner module fails
  now, everything should be cleaned up properly (and early) now, while
  all other (working) tuners are being usable. Proper errors are printed
  to the kernel log about this.

Mauro, I'm pretty sure you like this overall approach better, compared
to https://patchwork.linuxtv.org/patch/45810/ :-) In fact, I picked up
your idea of counting ports and act accordingly. Partial hardware setup
now starts up all working parts properly, while releasing resources
early when the nonworking parts are handled. If no ports could be started
at all, the driver instance will fail gracefully and report this to
upper layers.

I verified this by simply removing tda18212.ko with this DD setup:

* CineCTv6 bridge card (stv0367+tda18212 soldered on it, handled as
  port 0), one DuoFlex C2T2 connected to port 1 (cxd2841er+tda18212)
* Octopus CI Duo, one DuoFlex C2T2I (cxd2841er+tda18212) connected to
  port 1, one SingleCI module (cxd2099) connected to port 2

Upon modprobe ddbridge, the CTv6 will completely fail due to the tuner
driver not initialising (it's not there, actually). The OctoCIDUO
will fail on the C2T2I Flex, but starts up the CI hardware, registers
it's en50221 device nodes and things work fine with it. Unload cleans
up everything, no leaked usecounts, no KASAN complaints. Putting back
tda18212.ko, modprobe ddbridge - registers everything. Unload cleans
up everything properly aswell.

Not entirely sure, but patch 1 might be something for stable (ie. 4.14).

Daniel Scheller (8):
  [media] ddbridge: unregister I2C tuner client before detaching fe's
  [media] ddbridge: fix resources cleanup for CI hardware
  [media] ddbridge: deduplicate calls to dvb_ca_en50221_init()
  [media] ddbridge: move CI detach code to ddbridge-ci.c
  [media] ddbridge: completely tear down input resources on failure
  [media] ddbridge: fix deinit order in case of failure in ddb_init()
  [media] ddbridge: detach first input if the second one failed to init
  [media] ddbridge: improve ddb_ports_attach() failure handling

 drivers/media/pci/ddbridge/ddbridge-ci.c   |  17 +++--
 drivers/media/pci/ddbridge/ddbridge-ci.h   |   1 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 108 ++++++++++++++++++-----------
 3 files changed, 81 insertions(+), 45 deletions(-)

-- 
2.13.6
