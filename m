Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60382 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbbBPKu5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 05:50:57 -0500
Date: Mon, 16 Feb 2015 08:50:51 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv4 00/25] dvb core: add basic support for the media
 controller
Message-ID: <20150216085051.01f01e19@recife.lan>
In-Reply-To: <54E1BEA6.8060400@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<54DF1625.20808@xs4all.nl>
	<20150214090019.798b6d18@recife.lan>
	<54DF34E2.2020709@xs4all.nl>
	<20150215082716.45165770@recife.lan>
	<54E1BEA6.8060400@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Feb 2015 10:55:50 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/15/2015 11:27 AM, Mauro Carvalho Chehab wrote:

> > In any case, for ALSA, we should do the right thing here: remove (actually
> > deprecate) whatever definition is there, and then re-add it only when we
> > actually have the patches inside the ALSA subsystem to support the media
> > controller, plus having the corresponding patches for the media-ctl in order
> > to support the devnode discovery using both udev and sysfs for their nodes.
> 
> I actually thought about how alsa should be handled and it is doing the
> right thing. See my patch that I posted today, partially reverting your
> patch.

Well, I can live with that patch for now, but I suspect that removing
major/minor from ALSA will make things very complex at the userspace side.

Do you know how to convert from card/device/subdevice into a device node
patch using libudev and sysfs?

Regards,
Mauro
