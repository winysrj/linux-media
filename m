Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:58264 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZBPTcq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 14:32:46 -0500
Date: Mon, 16 Feb 2009 20:32:04 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [review patch 0/1] add firedtv driver for FireWire-attached DVB
 receivers
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net
cc: Christian Dolzer <c.dolzer@digital-everywhere.com>,
	Andreas Monitzer <andy@monitzer.com>,
	Manu Abraham <manu@linuxtv.org>,
	Fabio De Lorenzo <delorenzo.fabio@gmail.com>,
	Robert Berger <robert.berger@reliableembeddedsystems.com>,
	Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>,
	Rambaldi <Rambaldi@xs4all.nl>
Message-ID: <tkrat.265ed076d414bd49@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch in the follow-up mail contains the firedtv driver for
FireWire-attached DVB boxes from Digital Everywhere GmbH.  The driver
supports standard definition video reception (MPEG2-TS) of the DVB-C,
DVB-S/S2, and DVB-T boxes known as FireDTV (external devices) and
FloppyDTV (internal devices), their Common Interface for Conditional
Access Modules, and input from their infrared remote control.

High definition support is not yet implemented but people have voiced
interest to add it.

The driver is currently based on the ieee1394 driver stack but I started
to adapt it to the new firewire driver stack.

The driver was originally written by Andreas Monitzer and hosted in
linuxtv.org's v4l_experimental repository.  From there it went through
Greg KH's staging tree way before staging was added to mainline; from
there I picked it up for kernel.org's linux1394-2.6.git through which
it also was already exposed to linux-next for quite a while.

Manu Abraham, Ben Backx, and Henrik Kurelid updated and extended the
driver; I did lots of trivial cleanups and some refactoring and small
fixes.

The history of the driver sources beginning with its addition to
staging can be looked at in linux1394-2.6.git; find the shortlog below.

The patch is available for 2.6.29-rc* in linux1394-2.6.git's firedtv
branch:

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv

linux1394-2.6.git currently also contains backport branches:

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv-2.6.28
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv-2.6.27
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv-2.6.26
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv-2.6.25

Furthermore, firedtv is currently also available as patch tarballs and
as quilt series at

    http://user.in-berlin.de/~s5r6/linux1394/firedtv/2.6.29-rc5/
    http://user.in-berlin.de/~s5r6/linux1394/firedtv/2.6.28/
    http://user.in-berlin.de/~s5r6/linux1394/firedtv/2.6.27/
    http://user.in-berlin.de/~s5r6/linux1394/firedtv/2.6.26/
    http://user.in-berlin.de/~s5r6/linux1394/firedtv/2.6.25/

The history as in linux1394-2.6.git is fully "bisectable" i.e. does not
contain any known build bugs and a few minor known runtime bugs.

Addition of the interface with firewire-core will happen in
linux1394-2.6.git, but I expect longer-term maintenance of the driver to
be done via the DVB maintainers like with all other DVB drivers.

Comments on the patch in the following mail are very welcome.  I target
the pre 2.6.30-rc1 window for mainline merge request of the driver, but
if feedback in this review round is positive I would even ask if the
driver can already be included before 2.6.29.

Size of the patch is ~80 kB, I hope it fits through the mailing lists.

Shortlog and diffstat:

Ben Backx (2):
      firesat: fix DVB-S2 device recognition
      firesat: add DVB-S support for DVB-S2 devices

Greg Kroah-Hartman (1):
      DVB: add firesat driver

Henrik Kurelid (5):
      firesat: update isochronous interface, add CI support
      firesat: avc resend
      firedtv: fix returned struct for ca_info
      firedtv: use length_field() of PMT as length
      firedtv: fix registration - adapter number could only be zero

Julia Lawall (1):
      firedtv: Use DEFINE_SPINLOCK

Rambaldi (2):
      firedtv: rename files from firesat to firedtv
      firedtv: rename variables and functions from firesat to firedtv

Stefan Richter (54):
      firesat: add missing copyright notes
      firesat: rename to firedtv
      firedtv: nicer registration message and some initialization fixes
      firedtv: some header cleanups
      firedtv: replace semaphore by mutex
      firedtv: move some code back to ieee1394 core
      firedtv: replace tasklet by workqueue job
      firedtv: fix remote control input
      ieee1394: use correct barrier types between accesses of nodeid and generation
      ieee1394: add hpsb_node_read() and hpsb_node_lock()
      ieee1394: inherit ud vendor_id from node vendor_id
      firedtv: use hpsb_node_read(), _write(), _lock()
      firedtv: add vendor_id and version to driver match table
      firedtv: remove unused dual subunit code from initialization
      firedtv: fix initialization of dvb_frontend.ops
      firedtv: remove unused struct members
      firedtv: fix string comparison and a few sparse warnings
      firedtv: register input device as child of a FireWire device
      firedtv: remove various debug code
      firedtv: remove AV/C debug code
      firedtv: remove CA debug code
      firedtv: trivial cleanups in firesat-ci
      firedtv: trivial cleanups in cmp
      firedtv: remove bitfield typedefs from cmp, fix for big endian CPUs
      firedtv: don't retry oPCR updates endlessly
      firedtv: trivial cleanups in avc_api
      firedtv: trivial reorganization in avc_api
      firedtv: replace mdelay by msleep
      firedtv: increase FCP frame length for DVB-S2 tune QSPK
      firedtv: iso: style changes and fixlets
      firedtv: iso: remove unnecessary struct type definitions
      firedtv: iso: move code to firedtv-1394
      firedtv: cmp: move code to avc
      firedtv: avc: reduce stack usage, remove two typedefs
      firedtv: avc: fix offset in avc_tuner_get_ts
      firedtv: avc: remove bitfields from FCP frame types
      firedtv: avc: header file cleanup
      firedtv: avc: remove bitfields from DSD command operands
      firedtv: avc: remove bitfields from read descriptor response operands
      firedtv: avc, ci: remove unused constants
      firedtv: misc style touch-ups
      firedtv: combine header files
      firedtv: remove kernel version compatibility macro
      firedtv: amend Kconfig menu prompt
      firedtv: concentrate ieee1394 dependencies
      firedtv: replace EXTRA_CFLAGS by ccflags
      firedtv: allow build without input subsystem
      firedtv: dvb demux: fix missing braces
      firedtv: dvb demux: fix mutex protection
      firedtv: dvb demux: remove a bogus loop
      firedtv: dvb demux: some simplifications
      firedtv: dvb demux: more compact channels backing store
      firedtv: rename a file once more
      firedtv: some more housekeeping

 drivers/ieee1394/dma.h                    |    1 +
 drivers/ieee1394/ieee1394_core.c          |    1 +
 drivers/ieee1394/ieee1394_transactions.c  |   29 +
 drivers/ieee1394/ieee1394_transactions.h  |    2 +
 drivers/ieee1394/iso.h                    |    1 +
 drivers/ieee1394/nodemgr.c                |   10 +-
 drivers/ieee1394/nodemgr.h                |   18 +
 drivers/media/dvb/Kconfig                 |    4 +
 drivers/media/dvb/Makefile                |    2 +
 drivers/media/dvb/firewire/Kconfig        |   22 +
 drivers/media/dvb/firewire/Makefile       |    8 +
 drivers/media/dvb/firewire/firedtv-1394.c |  285 +++++++
 drivers/media/dvb/firewire/firedtv-avc.c  | 1235 +++++++++++++++++++++++++++++
 drivers/media/dvb/firewire/firedtv-ci.c   |  260 ++++++
 drivers/media/dvb/firewire/firedtv-dvb.c  |  364 +++++++++
 drivers/media/dvb/firewire/firedtv-fe.c   |  246 ++++++
 drivers/media/dvb/firewire/firedtv-rc.c   |  190 +++++
 drivers/media/dvb/firewire/firedtv.h      |  182 +++++
 18 files changed, 2857 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/dvb/firewire/Kconfig
 create mode 100644 drivers/media/dvb/firewire/Makefile
 create mode 100644 drivers/media/dvb/firewire/firedtv-1394.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-avc.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-ci.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-dvb.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-fe.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-rc.c
 create mode 100644 drivers/media/dvb/firewire/firedtv.h

-- 
Stefan Richter
-=====-==--= --=- =----
http://arcgraph.de/sr/

