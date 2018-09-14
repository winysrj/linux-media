Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f170.google.com ([209.85.208.170]:40480 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbeINNsh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 09:48:37 -0400
Received: by mail-lj1-f170.google.com with SMTP id j19-v6so6825967ljc.7
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2018 01:35:12 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 14 Sep 2018 10:34:54 +0200
Message-ID: <CAPybu_2VNJjMhB-XT=5XOPHXJvNc+K2ZvjHOyaJ74wZK6bwnGw@mail.gmail.com>
Subject: [RFP] Media Summit: Save/Restore controls from MTD
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Industrial/Scientific sensors usually come with very extensive
calibration information such as: per column gain, list of dead/pixels,
temperature sensor offset... etc

We are saving that information on an flash device that is located by the sensor.

I would like some minutes (15 max) to show you how we are integrating
that calibration flash with v4l2-ctrl. And if this feature is useful
for someone else and upstream it.

Thanks!

-- 
Ricardo Ribalda
