Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56089 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbbLCNfT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2015 08:35:19 -0500
Date: Thu, 3 Dec 2015 11:35:14 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@ucw.cz, andrew@lunn.ch, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 10/10] media: flash: use led_set_brightness_sync for
 torch brightness
Message-ID: <20151203113514.06754498@recife.lan>
In-Reply-To: <5649A64E.8050907@linux.intel.com>
References: <1444209048-29415-1-git-send-email-j.anaszewski@samsung.com>
	<1444209048-29415-11-git-send-email-j.anaszewski@samsung.com>
	<5649A37A.2050902@samsung.com>
	<5649A64E.8050907@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Nov 2015 11:47:58 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Jacek Anaszewski wrote:
> > This patch depends on the preceding LED core improvements patches
> > from this patch set, and it would be best if it was merged through
> > the LED tree. Can I get your ack for this? I've already obtained acks
> > for the whole set from Sakari.
> 
> I agree with this going through the LED tree.

Feel free to send it via the LED tree.

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Regards,
Mauro
