Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:56457 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbAZOll (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 09:41:41 -0500
Received: by mail-qc0-f182.google.com with SMTP id l6so7127195qcy.13
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 06:41:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150126123129.2076b9f8@recife.lan>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
	<cb0517f150942a2d3657c1f2e55754061bfae2c4.1422273497.git.mchehab@osg.samsung.com>
	<54C63D16.3070607@xs4all.nl>
	<20150126113416.311fb376@recife.lan>
	<CAGoCfixoSxspEzpCB95BVPXBrZr2gpDVWHbaikESsuB1V=WM1g@mail.gmail.com>
	<20150126123129.2076b9f8@recife.lan>
Date: Mon, 26 Jan 2015 09:41:41 -0500
Message-ID: <CAGoCfiwi0nj_9sYNzEFOp5BvedFe+HphJ2bVtx_bnBw3d-Bsyw@mail.gmail.com>
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

> It is actually trivial to get the device nodes once you have the
> major/minor. The media-ctl library does that for you. See:

No objection then.

On a related note, you would be very well served to consider testing
your dvb changes with a device that has more than one DVB tuner (such
as the hvr-2200/2250).  That will help you shake out any edge cases
related to ensuring that the different DVB nodes appear in different
groups.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
