Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:40018 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbeDGGMT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 02:12:19 -0400
Received: by mail-wr0-f173.google.com with SMTP id n2so3483138wrj.7
        for <linux-media@vger.kernel.org>; Fri, 06 Apr 2018 23:12:18 -0700 (PDT)
MIME-Version: 1.0
From: asadpt iqroot <asadptiqroot@gmail.com>
Date: Sat, 7 Apr 2018 11:42:17 +0530
Message-ID: <CA+gCWtKhgDPq_bpiARSTpVvU+tLr3ErOHBAir6BRR_YKuEVHRg@mail.gmail.com>
Subject: sensor driver configuration
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

How to configure the below parameters:

Color Format: YUV_422
Color Depth: 12
Pixels Per Clock: 2

In Sensor driver and device tree, how to configure these values.

In Sensor driver, we may use the macro like this MEDIA_BUS_FMT_UYVY8_1X16.
But have the doubts on this. How to specify this Pixels per clock??


Thanks
-asadpt
