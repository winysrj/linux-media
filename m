Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab2AEBBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 00/47] Add mt2063 frontend driver
Date: Wed,  4 Jan 2012 23:00:11 -0200
Message-Id: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new driver for mt2063 tuner. 

This driver come originally from Terratec:
	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz

And it is GPL'd, as declared at MODULE_LICENSE().

The original code doesn't met Linux Coding Style, and had several bad issues
on it. This patch series import the original driver, convert it to use the 
DVBv5 structures, instead of the DVBv3 ones, and make it work.

This driver is part of my experimental tree for az6007:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/az6007-2

There are still some non-tuner related issues on the az6007, so the az6007 
driver is not ready for submission. Yet, Stefan is working on another driver
that needs mt2063 and this driver works.

So, there's no reason to postpone its addition upstream.

I decided to add, at the end, two small patches for DRX-K, also part of the
az6007 series. One is a debug msg improvement, and the other one adds support
for selecting between parallel and serial mode. The default didn't change, so
it should also be ok to apply it.

Mauro Carvalho Chehab (47):
  [media] add driver for mt2063
  [media] mt2063: CodingStyle fixes
  [media] mt2063: Fix some Coding styles at mt2063.h
  [media] mt2063: Move code from mt2063_cfg.h
  [media] mt2063: Fix the driver to make it compile
  [media] mt2063: Use standard Linux types, instead of redefining them
  [media] mt2063: Remove most of the #if's
  [media] mt2063: Re-define functions as static
  [media] mt2063: Remove unused stuff
  [media] mt2063: get rid of compilation warnings
  [media] mt2063: Move data structures to the driver
  [media] mt2063: Remove internal version checks
  [media] mt2063: Use Unix standard error handling
  [media] mt2063: Remove unused data structures
  [media] mt2063: Merge the two state structures into one
  [media] mt2063: Use state for the state structure
  [media] mt2063: Remove the code for more than one adjacent mt2063  tuners
  [media] mt2063: Rewrite read/write logic at the driver
  [media] mt2063: Simplify some functions
  [media] mt2063: Simplify device init logic
  [media] mt2063: Don't violate the DVB API
  [media] mt2063: Use linux default max function
  [media] mt2063: Remove several unused parameters
  [media] mt2063: simplify lockstatus logic
  [media] mt2063: Simplify mt2063_setTune logic
  [media] mt2063: Rework on the publicly-exported functions
  [media] mt2063: Remove setParm/getParm abstraction layer
  [media] mt2063: Reorder the code to avoid function prototypes
  [media] mt2063: Cleanup some function prototypes
  [media] mt2063: make checkpatch.pl happy
  [media] mt2063: Fix analog/digital set params logic
  [media] mt2063: Fix comments
  [media] mt2063: Rearrange the delivery system functions
  [media] mt2063: Properly document the author of the original driver
  [media] mt2063: Convert it to the DVBv5 way for set_params()
  [media] mt2063: Add some debug printk's
  [media] mt2063: Rewrite tuning logic
  [media] mt2063: Remove two unused temporary vars
  [media] mt2063: don't crash if device is not initialized
  [media] mt2063: Print a message about the detected mt2063 type
  [media] mt2063: Fix i2c read message
  [media] mt2063: print the detected version
  [media] mt2063: add some useful info for the dvb callback calls
  [media] mt2063: Add support for get_if_frequency()
  [media] mt2063: Add it to the building system
  [media] drxk: Improve a few debug messages
  [media] drxk: Add support for parallel mode and prints mpeg mode

 drivers/media/common/tuners/Kconfig     |    7 +
 drivers/media/common/tuners/Makefile    |    1 +
 drivers/media/common/tuners/mt2063.c    | 2307 +++++++++++++++++++++++++++++++
 drivers/media/common/tuners/mt2063.h    |   36 +
 drivers/media/dvb/frontends/drxk.h      |    3 +
 drivers/media/dvb/frontends/drxk_hard.c |   26 +-
 6 files changed, 2371 insertions(+), 9 deletions(-)
 create mode 100644 drivers/media/common/tuners/mt2063.c
 create mode 100644 drivers/media/common/tuners/mt2063.h

-- 
1.7.7.5

