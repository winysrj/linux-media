Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:61085 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab0EaPJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 11:09:36 -0400
Received: by ewy8 with SMTP id 8so990867ewy.28
        for <linux-media@vger.kernel.org>; Mon, 31 May 2010 08:09:35 -0700 (PDT)
Date: Mon, 31 May 2010 17:09:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: dereferencing uninitialized variable in anysee_probe()
Message-ID: <20100531150914.GX5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi I'm going through some smatch stuff and I had a question.

drivers/media/dvb/dvb-usb/anysee.c +482 anysee_probe(30)
	warn: variable dereferenced before check 'd'

   466          ret = dvb_usb_device_init(intf, &anysee_properties, THIS_MODULE, &d,
   467                  adapter_nr);

	If we're in a cold state then dvb_usb_device_init() can return
	zero but d is uninitialized here.

   468          if (ret)
   469                  return ret;
   470
   471          alt = usb_altnum_to_altsetting(intf, 0);
   472          if (alt == NULL) {
   473                  deb_info("%s: no alt found!\n", __func__);
   474                  return -ENODEV;
   475          }
   476
   477          ret = usb_set_interface(d->udev, alt->desc.bInterfaceNumber,
                                        ^^^^^^^
	That would lead to an oops here.

   478                  alt->desc.bAlternateSetting);

I'm not sure how to fix this.

regards,
dan carpenter
