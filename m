Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:37860 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbeDGJs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 05:48:28 -0400
Received: by mail-wr0-f171.google.com with SMTP id l49so3744633wrl.4
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2018 02:48:27 -0700 (PDT)
MIME-Version: 1.0
From: asadpt iqroot <asadptiqroot@gmail.com>
Date: Sat, 7 Apr 2018 15:18:26 +0530
Message-ID: <CA+gCWt+pDSB-A2EgMN5oFZkt+vthQ8gWo=gLe62j9LUC671jzA@mail.gmail.com>
Subject: v4l2 configuration doubt
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Need to configure below parameter:

Color Format: RGB888
Color Depth: 8
Pixels Per Clock: 2

Is there any macro available for this configuration like
MEDIA_BUS_FMT_RGB888_1X24?
How to configure pixel per clock in device tree and driver file?

Thanks & Regards
- Asad
