Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:38657 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbeBQUsC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Feb 2018 15:48:02 -0500
Received: by mail-lf0-f49.google.com with SMTP id g72so8343272lfg.5
        for <linux-media@vger.kernel.org>; Sat, 17 Feb 2018 12:48:01 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Sat, 17 Feb 2018 15:47:59 -0500
Message-ID: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com>
Subject: Bug: Two device nodes created in /dev for a single UVC webcam
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm running Linux 4.9.0-5-amd64 on Debian. I built the drivers from
the latest git and installed the modules. Now, two device nodes are
created for my webcam. This is not normal as it has never happened to
me before. If I connect another webcam to my laptop, two more device
nodes will be created for this webcam. So two new device nodes are
created for a single webcam.

The name of my webcam appears twice in the device comobox in Guvcview
because of this. One of them will not work if I select it. My webcam
has completely stopped working with Cheese and VLC.

> v4l2-ctl --list-devices
Laptop_Integrated_Webcam_E4HD:  (usb-0000:00:1a.0-1.5):
    /dev/video0
    /dev/video1

> ls /dev/video*
/dev/video0  /dev/video1

Have a nice day,
Alexandre-Xavier
