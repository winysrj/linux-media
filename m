Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbbACUJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 15:09:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/7] add link graph to cx231xx using the media controller
Date: Sat,  3 Jan 2015 18:09:32 -0200
Message-Id: <cover.1420315245.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series depends on the patch media controller patch series
sent previously. The full set of patches are at:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=dvb-media-ctl

It adds the logic needed to create the remaining media PADs and the
links to represent the media graph.

TODO:
- The links are now static and don't change when the device is switched
  to DVB mode.

With this change:

Media controller API version 0.1.1

Media device information
------------------------
driver          cx231xx
model           Pixelview PlayTV USB Hybrid
serial          CIR000000000001
bus info        4
hw revision     0x4001
driver version  3.19.0

Device topology
- entity 1: cx25840 19-0044 (3 pads, 3 links)
            type V4L2 subdev subtype Decoder flags 0
	pad0: Sink
		<- "NXP TDA18271HD":0 [ENABLED]
	pad1: Source
		-> "cx231xx #0 video":0 [ENABLED]
	pad2: Source
		-> "cx231xx #0 vbi":0 [ENABLED]

- entity 2: NXP TDA18271HD (1 pad, 2 links)
            type V4L2 subdev subtype Tuner flags 0
	pad0: Source
		-> "cx25840 19-0044":0 [ENABLED]
		-> "Fujitsu mb86A20s":0 []

- entity 3: cx231xx #0 video (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
	pad0: Sink
		<- "cx25840 19-0044":1 [ENABLED]

- entity 4: cx231xx #0 vbi (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/vbi0
	pad0: Sink
		<- "cx25840 19-0044":2 [ENABLED]

- entity 5: Fujitsu mb86A20s (2 pads, 2 links)
            type Node subtype DVB FE flags 0
            device node name /dev/dvb/adapter0/frontend0
	pad0: Sink
		<- "NXP TDA18271HD":0 []
	pad1: Source
		-> "demux":0 []

- entity 6: demux (2 pads, 2 links)
            type Node subtype DVB DEMUX flags 0
            device node name /dev/dvb/adapter0/demux0
	pad0: Sink
		<- "Fujitsu mb86A20s":1 []
	pad1: Source
		-> "dvr":0 []

- entity 7: dvr (1 pad, 1 link)
            type Node subtype DVB DVR flags 0
            device node name /dev/dvb/adapter0/dvr0
	pad0: Sink
		<- "demux":1 []

- entity 8: dvb net (0 pad, 0 link)
            type Node subtype DVB NET flags 0
            device node name /dev/dvb/adapter0/net0


Mauro Carvalho Chehab (7):
  tuner-core: properly initialize media controller subdev
  cx25840: fill the media controller entity
  cx231xx: initialize video/vbi pads
  cx231xx: create media links for analog mode
  dvbdev: represent frontend with two pads
  dvbdev: add a function to create DVB media graph
  cx231xx: create DVB graph

 drivers/media/dvb-core/dvbdev.c           | 59 ++++++++++++++++++++++++++++---
 drivers/media/dvb-core/dvbdev.h           |  1 +
 drivers/media/i2c/cx25840/cx25840-core.c  | 14 +++++++-
 drivers/media/i2c/cx25840/cx25840-core.h  |  3 ++
 drivers/media/usb/cx231xx/cx231xx-cards.c | 40 +++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   |  1 +
 drivers/media/usb/cx231xx/cx231xx-video.c | 13 ++++++-
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 drivers/media/v4l2-core/tuner-core.c      | 15 ++++++++
 include/uapi/linux/media.h                |  2 ++
 10 files changed, 142 insertions(+), 7 deletions(-)

-- 
2.1.0

DOT file with the graph:

digraph board {
	rankdir=TB
	n00000001 [label="{{<port0> 0} | cx25840 19-0044 | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000001:port1 -> n00000003
	n00000001:port2 -> n00000004
	n00000002 [label="{{} | NXP TDA18271HD | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000002:port0 -> n00000001:port0
	n00000002:port0 -> n00000005 [style=dashed]
	n00000003 [label="cx231xx #0 video\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
	n00000004 [label="cx231xx #0 vbi\n/dev/vbi0", shape=box, style=filled, fillcolor=yellow]
	n00000005 [label="Fujitsu mb86A20s\n/dev/dvb/adapter0/frontend0", shape=box, style=filled, fillcolor=yellow]
	n00000005 -> n00000006 [style=dashed]
	n00000006 [label="demux\n/dev/dvb/adapter0/demux0", shape=box, style=filled, fillcolor=yellow]
	n00000006 -> n00000007 [style=dashed]
	n00000007 [label="dvr\n/dev/dvb/adapter0/dvr0", shape=box, style=filled, fillcolor=yellow]
	n00000008 [label="dvb net\n/dev/dvb/adapter0/net0", shape=box, style=filled, fillcolor=yellow]
}
