Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:10012 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbbKPJsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 04:48:03 -0500
Subject: Re: [PATCH v3 10/10] media: flash: use led_set_brightness_sync for
 torch brightness
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@ucw.cz, andrew@lunn.ch, linux-media@vger.kernel.org
References: <1444209048-29415-1-git-send-email-j.anaszewski@samsung.com>
 <1444209048-29415-11-git-send-email-j.anaszewski@samsung.com>
 <5649A37A.2050902@samsung.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <5649A64E.8050907@linux.intel.com>
Date: Mon, 16 Nov 2015 11:47:58 +0200
MIME-Version: 1.0
In-Reply-To: <5649A37A.2050902@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jacek Anaszewski wrote:
> This patch depends on the preceding LED core improvements patches
> from this patch set, and it would be best if it was merged through
> the LED tree. Can I get your ack for this? I've already obtained acks
> for the whole set from Sakari.

I agree with this going through the LED tree.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
