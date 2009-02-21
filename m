Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZBULvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 06:51:21 -0500
Date: Sat, 21 Feb 2009 08:50:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090221085046.3ebfccb3@pedra.chehab.org>
In-Reply-To: <200902180006.38763.hverkuil@xs4all.nl>
References: <20090217142327.1678c1a6@hyperion.delvare>
	<200902172324.03697.laurent.pinchart@skynet.be>
	<200902180006.38763.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009 00:06:38 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Especially companies like Texas Instruments that 
> are working on new v4l2 drivers for the embedded space (omap, davinci) are 
> quite annoyed and confused by all the backwards compatibility stuff that 
> we're dragging along. I find it much more important to cater to their needs 
> than to support a driver on an ancient kernel for some anonymous company. 

The i2c code or any other backported code shouldn't affect any new driver. 

For new drivers, they can just use 2.6.29-rc as reference and mark
that the minimum required version for it is 2.6.30, at v4l/versions.txt. 

If the driver is for x86/x86_64, it generally makes sense to preserve the
backward compat bits, to help users.

However, in the specific case of TI development, for OMAP and similar drivers
that are specific to some embedded architecture, and where a normal user will
never need to test it for us, since the vendor is responsible for the driver,
it is perfectly fine to update v4l/versions.txt for each new version that needs
something for a newer API.

Cheers,
Mauro
