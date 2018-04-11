Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f45.google.com ([209.85.160.45]:46995 "EHLO
        mail-pl0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbeDKKDv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 06:03:51 -0400
Received: by mail-pl0-f45.google.com with SMTP id 59-v6so1016565plc.13
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 03:03:50 -0700 (PDT)
MIME-Version: 1.0
From: asadpt iqroot <asadptiqroot@gmail.com>
Date: Wed, 11 Apr 2018 15:33:50 +0530
Message-ID: <CA+gCWtKWYE4+F8gHEYYjvNrkCV7G0VNjGq11SC2MRSqP9N8Yog@mail.gmail.com>
Subject: sensor driver - v4l2 - MEDIA_BUS_FMT
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

We are trying develop a sensor driver code for hdmi2csi adapter.
Reguired data format is RGB888. But in media format header file, we
could see three macros related to RGB888. Hardware connection is mipi
csi2.

#define MEDIA_BUS_FMT_RGB888_1X24 0x100a
#define MEDIA_BUS_FMT_RGB888_2X12_BE 0x100b
#define MEDIA_BUS_FMT_RGB888_2X12_LE 0x100c

How to decide whether we go for RGB888_1X24 or RGB888_2X12 macros.


Thanks & Regards
- Asad
