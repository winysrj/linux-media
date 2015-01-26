Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:42316 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbAZOAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 09:00:54 -0500
Received: by mail-qa0-f41.google.com with SMTP id bm13so6769586qab.0
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 06:00:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150126113416.311fb376@recife.lan>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
	<cb0517f150942a2d3657c1f2e55754061bfae2c4.1422273497.git.mchehab@osg.samsung.com>
	<54C63D16.3070607@xs4all.nl>
	<20150126113416.311fb376@recife.lan>
Date: Mon, 26 Jan 2015 09:00:46 -0500
Message-ID: <CAGoCfixoSxspEzpCB95BVPXBrZr2gpDVWHbaikESsuB1V=WM1g@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: Fix ALSA and DVB representation at media
 controller API
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Ricardo Ribalda <ricardo.ribalda@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> For media-ctl, it is easier to handle major/minor, in order to identify
> the associated devnode name. Btw, media-ctl currently assumes that all
> devnode devices are specified by v4l.major/v4l.minor.

I suspect part of the motivation for the "id" that corresponds to the
adapter field was to make it easier to find the actual underlying
device node.  While it's trivial to convert a V4L device node from
major/minor to the device node (since for major number is constant and
the minor corresponds to the X in /dev/videoX), that's tougher with
DVB adapters because of the hierarchical nature of the DVB device
nodes.  Having the adapter number makes it trivial to open
/dev/dvb/adapterX.

Perhaps my POSIX is rusty -- is there a way to identify the device
node based on major minor without having to traverse the entire /dev
tree?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
