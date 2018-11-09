Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-40130.protonmail.ch ([185.70.40.130]:55194 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbeKJH4X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 02:56:23 -0500
Date: Fri, 09 Nov 2018 22:13:41 +0000
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: softwarebugs <softwarebugs@protonmail.com>
Reply-To: softwarebugs <softwarebugs@protonmail.com>
Subject: spca561 webcam support, broken since v4.18
Message-ID: <taFBrydQuf6RksksscTtnsylwhc3ziL3dSSKa_Mg40a2sF589DdD9DBhu2zHPeSVsWX44dAksOmiPBw-jJ0hAl5oQIW5pZiPvLzlefOL6n4=@protonmail.com>
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
