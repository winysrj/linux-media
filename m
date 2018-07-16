Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35804 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbeGPGb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 02:31:27 -0400
Received: by mail-it0-f52.google.com with SMTP id l16-v6so19512426ita.0
        for <linux-media@vger.kernel.org>; Sun, 15 Jul 2018 23:05:43 -0700 (PDT)
MIME-Version: 1.0
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Sun, 15 Jul 2018 23:05:42 -0700
Message-ID: <CAJCx=g=+GWrPTWpU_AgGKLKWtXY57c=7i-1ijMVdJP=scRqyYw@mail.gmail.com>
Subject: [RFC] media: thermal I2C cameras metadata
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello et all,

So currently working with some thermal sensors that have coefficients
that needs to be passed back to userspace that aren't related to the
pixel data but are required to normalize to remove scan patterns and
temp gradients. Was wondering the best way to do this, and hope it
isn't some is kludge of the close captioning, or just passing raw data
as another column line.

Datasheet: https://www.melexis.com/en/product/MLX90640/Far-Infrared-Thermal-Sensor-Array

Thanks,

Matt
