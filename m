Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-40133.protonmail.ch ([185.70.40.133]:61359 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbeKJIHi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 03:07:38 -0500
Date: Fri, 09 Nov 2018 22:24:55 +0000
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: softwarebugs <softwarebugs@protonmail.com>
Reply-To: softwarebugs <softwarebugs@protonmail.com>
Subject: spca561 webcam support, broken since v4.18
Message-ID: <cmslSrq7sftuPGsRPzPapsZOcZ2b4G25B48YY76irceURUtGSDd5_GqqALr46RyQ4orzJIh4CK8F99lF-CXoBMM-cOw-R_100bD-2zn-mL0=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4.17.19 is the last version it works with. Since v4.18 I cannot use it.

from the lsusb output:

ID 04fc:0561 Sunplus Technology Co., Ltd Flexcam 100

from the dmesg output:

After a restart, after I click to make it start capturing (the bandwidth
message appears only when the first capturing is started):

spca561 : alt 7 - bandwidth not wide enough, trying again
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200
spca561 : frame overflow 19793 > 19200

After clicking to make it stop capturing:

spca561 : urb status: -2
gspca_main: usb_submit_urb() ret -1
spca561 : urb status: -2
gspca_main: usb_submit_urb() ret -1
spca561 : urb status: -2
gspca_main: usb_submit_urb() ret -1
