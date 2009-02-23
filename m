Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZBWCjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 21:39:08 -0500
Date: Sun, 22 Feb 2009 23:38:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: CityK <cityk@rogers.com>
Cc: sebastian.blanes@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add "Sony PlayTV" to dibcom driver
Message-ID: <20090222233839.566f2870@pedra.chehab.org>
In-Reply-To: <49A1AFBD.7030208@rogers.com>
References: <9160c0600902190120w705b3d55jf4aa1af3418e5c62@mail.gmail.com>
	<49A1AFBD.7030208@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 22 Feb 2009 15:04:13 -0500
CityK <cityk@rogers.com> wrote:

> I don't think the Patchwork tool picked it up, as I don't see it in the
> queue :(
> http://patchwork.kernel.org/project/linux-media/list/
> 
> I'm wondering it the quotations in the subject line are enough to throw
> the script off.  Mauro, any ideas?

In general those tools to pick and work with scripts don't like very much
inlined patches, although it generally works.

Also, it requires that the patch is not line wrapped.

In this specific case, the patch is line-wrapped:

--- v4l-dvb-359d95e1d541-vanilla/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18
13:49:37.000000000 +0100
+++ v4l-dvb-359d95e1d541/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18
23:45:43.000000000 +0100

instead of:

--- v4l-dvb-359d95e1d541-vanilla/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18 13:49:37.000000000 +0100
+++ v4l-dvb-359d95e1d541/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18 23:45:43.000000000 +0100


So, it doesn't apply as a patch and patchwork discards it.

Sebastian, 

could you please send it again, being sure that your email won't break long
lines?


Cheers,
Mauro
