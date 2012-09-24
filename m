Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-01.vtx.ch ([194.38.175.90]:56041 "EHLO smtp-01.vtx.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab2IXIAG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 04:00:06 -0400
Received: from tuxstudio (dyn.83-228-182-235.dsl.vtx.ch [83.228.182.235])
	by smtp-01.vtx.ch (VTX Services SA) with ESMTP id DFD482925B
	for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 08:54:39 +0200 (CEST)
Date: Mon, 24 Sep 2012 09:51:23 +0200
From: Dominique Michel <dominique.michel@vtxnet.ch>
To: linux-media@vger.kernel.org
Subject: HVR 4000 and DVB-API
Message-ID: <20120924095123.7db56ab3@tuxstudio>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The WinTV HVR-4000-HD is a multi-tuners TV card with 2 dvb tuners.
It look like its driver doesn't have been updated to the new DVB-API.

The problem I get with dvr is than vdr only seam to recognize and use
the first tuner of my Hauppauge WinTV HVR-4000-HD. The devices are
in /dev/dvb/adapter0:

# ls /dev/dvb/adapter0
demux0  demux1  dvr0  dvr1  frontend0  frontend1  net0  net1

frontend0 is the dvb-s tuner and frontedn1 is the dvb-t/c tuner, and I
want to be able to use both of them. It is a hardware limitation in
that card (among other) that make not possible to use those 2 tuners at
the same time.

When starting vdr, the only error message I get at the console is, when
I make udev to create symlinks like /dev/dvb/adapter1/*0
to /dev/dvb/adapter0/*1:

 * VDR errors from /var/log/messages:
 *   ERROR: /dev/dvb/adapter1/frontend0: Device or resource busy

I can use mplayer instead of vdr. It work with the symiliks with
"mplayer dvb://2@", and without the symlinks by acceding directly the
adapter0/drv1 device after tuning with tzap. When trying to access one
of the dvb-t channels from shmclient, it tell me "Channel not
available".

vdr holds an opened handle on the frontend during its running time.
Since the DVB-S frontend is the first one, DVB-T does not work. Some
months ago the linux-media DVB-API was extended so multiple delivery
systems can be accessed through one frontend, if they are mutually
exclusive. Sadly the driver for the HVR 4000 was forgotten.

I don't want to buy another TV card or a TV set. So, can I hope than,
in the reasonably near future, someone on this list will get some time
to fix and update the HVR 4000 driver?

Dominique
-- 
"We have the heroes we deserve."
