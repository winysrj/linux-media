Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35525 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbeAEPjX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 10:39:23 -0500
Received: by mail-qk0-f169.google.com with SMTP id 143so6368089qki.2
        for <linux-media@vger.kernel.org>; Fri, 05 Jan 2018 07:39:22 -0800 (PST)
Received: from mail-qk0-f171.google.com (mail-qk0-f171.google.com. [209.85.220.171])
        by smtp.gmail.com with ESMTPSA id 46sm3696593qtx.65.2018.01.05.07.39.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jan 2018 07:39:21 -0800 (PST)
Received: by mail-qk0-f171.google.com with SMTP id i17so1980270qke.0
        for <linux-media@vger.kernel.org>; Fri, 05 Jan 2018 07:39:21 -0800 (PST)
MIME-Version: 1.0
From: Olli Salonen <olli.salonen@iki.fi>
Date: Fri, 5 Jan 2018 16:39:20 +0100
Message-ID: <CAAZRmGzMyQv4DZiU33+N3qWkZkuXb53fZZiK881NU3u+SS0O6Q@mail.gmail.com>
Subject: Mygica 230C defined in two drivers
To: stefan.bruens@rwth-aachen.de,
        linux-media <linux-media@vger.kernel.org>
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan and all,

I noticed that the Mygica 230C is currently defined in two different drivers.

in dvbsky.c:

    { DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C,
        &mygica_t230c_props, "MyGica Mini DVB-T2 USB Stick T230C",
        RC_MAP_TOTAL_MEDIA_IN_HAND_02) },


in cxusb.c:

    [MYGICA_T230] = {
        USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230)
    },
    [MYGICA_T230C] = {
        USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230+1)
    },

and in dvb-usb-ids.h:

#define USB_PID_MYGICA_T230                    0xc688
#define USB_PID_MYGICA_T230C                0xc689

I think you've played around with this device earlier. Do you have any
insight on which driver works better or all they all the same?

Cheers,
-olli
