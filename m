Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:59566 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbcAZWCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 17:02:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/7] [media] em28xx: add MEDIA_TUNER dependency
Date: Tue, 26 Jan 2016 23:01:48 +0100
Message-ID: <5964838.Fz0P6fH3v7@wuerfel>
In-Reply-To: <20160126150819.04cab5a9@recife.lan>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de> <5775609.WPlM7VCgVr@wuerfel> <20160126150819.04cab5a9@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 26 January 2016 15:08:19 Mauro Carvalho Chehab wrote:
> > > Ok, if we'll have platform drivers for analog TV using the I2C bus
> > > at directly in SoC, then your solution is better, but the tuner core
> > > driver may not be the best way of doing it. So, for now, I would use
> > > the simpler version.  
> > 
> > Ok. Do you want me to submit a new version or do you prefer to write
> > one yourself? With or without the 'default'?
> 
> Feel free to submit a new version without the default.
> 
> 

Ok, done.

	Arnd
