Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36729 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaJYS3O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Oct 2014 14:29:14 -0400
Date: Sat, 25 Oct 2014 11:03:07 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Tomas Melin <tomas.melin@iki.fi>
Cc: m.chehab@samsung.com, james.hogan@imgtec.com, a.seppala@gmail.com,
	bay@hackerdom.ru, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] [media] rc-core: fix protocol_change regression
 in ir_raw_event_register
Message-ID: <20141025090307.GA31078@hardeman.nu>
References: <1413916218-7481-1-git-send-email-tomas.melin@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413916218-7481-1-git-send-email-tomas.melin@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 21, 2014 at 09:30:17PM +0300, Tomas Melin wrote:
>IR reciever using nuvoton-cir and lirc required additional configuration
>steps after upgrade from kernel 3.16 to 3.17-rcX.
>Bisected regression to commit da6e162d6a4607362f8478c715c797d84d449f8b
>("[media] rc-core: simplify sysfs code").
>
>The regression comes from adding empty function change_protocol in
>ir-raw.c. It changes behaviour so that only the protocol enabled by driver's
>map_name will be active after registration. This breaks user space behaviour,
>lirc does not get key press signals anymore.
>
>Changed back to original behaviour by removing empty function
>change_protocol in ir-raw.c. Instead only calling change_protocol for

Wouldn't something like this be a simpler way of achieving the same
result? (untested):


diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a7991c7..d521f20 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1421,6 +1421,9 @@ int rc_register_device(struct rc_dev *dev)
 
 	if (dev->change_protocol) {
 		u64 rc_type = (1 << rc_map->rc_type);
+		if (dev->driver_type == RC_DRIVER_IR_RAW)
+			rc_type |= RC_BIT_LIRC;
+
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_raw;

