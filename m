Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31637 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbaFLOaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 10:30:23 -0400
Date: Thu, 12 Jun 2014 17:30:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org
Subject: re: [media] dvb_usb_v2: use dev_* logging macros
Message-ID: <20140612143002.GC13103@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti Palosaari,

This is a semi-automatic email about new static checker warnings.

The patch d10d1b9ac97b: "[media] dvb_usb_v2: use dev_* logging
macros" from Jun 26, 2012, leads to the following Smatch complaint:

drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:31 dvb_usb_v2_generic_io()
	 error: we previously assumed 'd' could be null (see line 29)

drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
    28	
    29		if (!d || !wbuf || !wlen || !d->props->generic_bulk_ctrl_endpoint ||
                    ^^
Old check.

    30				!d->props->generic_bulk_ctrl_endpoint_response) {
    31			dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, -EINVAL);
                                ^^^^^^^^^^^^^
New dereference.

    32			return -EINVAL;
    33		}

regards,
dan carpenter
