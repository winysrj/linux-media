Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42594 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbbACCIg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jan 2015 21:08:36 -0500
Date: Sat, 3 Jan 2015 00:08:26 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/7] dvb core: add basic support for the media
 controller
Message-ID: <20150103000826.468fd4ba@concha.lan>
In-Reply-To: <cover.1420250453.git.mchehab@osg.samsung.com>
References: <cover.1420250453.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 03 Jan 2015 00:04:33 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> This patch series adds basic support for the media controller at the
> DVB core: it creates one media entity per DVB devnode, if the media
> device is passed as an argument to the DVB structures.
> 
> The cx231xx driver was modified to pass such argument for DVB NET,
> DVB frontend and DVB demux.

Forgot to add here, but it is probably worth to show the output of
media-ctl showing the entities created on cx231xx:

$ /usr/local/bin/media-ctl -p
Media controller API version 0.1.1

Media device information
------------------------
driver          cx231xx
model           Pixelview PlayTV USB Hybrid
serial          CIR000000000001
bus info        1.2
hw revision     0x4001
driver version  3.19.0

Device topology
- entity 1: cx25840 19-0044 (0 pad, 0 link)
            type V4L2 subdev subtype Unknown flags 0

- entity 2: tuner 21-0060 (0 pad, 0 link)
            type V4L2 subdev subtype Unknown flags 0

- entity 3: cx231xx #0 video (0 pad, 0 link)
            type Node subtype V4L flags 0
            device node name /dev/video0

- entity 4: cx231xx #0 vbi (0 pad, 0 link)
            type Node subtype V4L flags 0
            device node name /dev/vbi0

- entity 5: Fujitsu mb86A20s (0 pad, 0 link)
            type Node subtype DVB flags 20005

- entity 6: demux (0 pad, 0 link)
            type Node subtype DVB flags 20006

- entity 7: dvr (0 pad, 0 link)
            type Node subtype DVB flags 20007

- entity 8: dvb net (0 pad, 0 link)
            type Node subtype DVB flags 20009

PS.: I didn't patch yet the media-ctl to better enumerate the DVB devices.

Cheers,
Mauro
