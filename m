Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58572 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbeGBM6x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 08:58:53 -0400
To: Akihiro Tsukada <tskd08@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
From: Colin Ian King <colin.king@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: re: media: dvb-usb-v2/gl861: ensure USB message buffers DMA'able
Message-ID: <8308d9f0-2257-101c-69e3-8fe165de9348@canonical.com>
Date: Mon, 2 Jul 2018 13:58:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

While running static analysis on linux-next with CoverityScan an issue
was detected with recent commit:

commit 86f65c218123c4e36fd855fbbc38147ffaf29974
Author: Akihiro Tsukada <tskd08@gmail.com>
Date:   Sun Apr 8 13:21:38 2018 -0400

    media: dvb-usb-v2/gl861: ensure USB message buffers DMA'able

The report is as follows:

46        }

assign_zero: Assigning: buf = NULL.

 47        buf = NULL;

Condition rlen > 0, taking false branch.

 48        if (rlen > 0) {
 49                buf = kmalloc(rlen, GFP_KERNEL);
 50                if (!buf)
 51                        return -ENOMEM;
 52        }

 53        usleep_range(1000, 2000); /* avoid I2C errors */
 54
   CID 1470241 (#1 of 1): Explicit null dereferenced (FORWARD_NULL).
var_deref_model: Passing null pointer buf to usb_control_msg, which
dereferences it.

 55        ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
req, type,
 56                              value, index, buf, rlen, 2000);


The assignment of buf = NULL means a null buffer is passed down the usb
control message stack until it eventually gets dereferenced. This only
occurs when rlen <= 0.   I was unsure how to fix this for the case when
rlen <= 0, so I am flagging this up as an issue that needs fixing.

Regards,

Colin
