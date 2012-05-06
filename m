Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51697 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2EFAL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 20:11:59 -0400
Received: by obbtb18 with SMTP id tb18so6107695obb.19
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 17:11:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 May 2012 20:11:58 -0400
Message-ID: <CACOfU4NXM5itsw17bRhtNeDP+-dbCM+Ms84k47NbPf6NjzOmtw@mail.gmail.com>
Subject: error - cx18 driver
From: Hector Catre <hcatre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note: I’m a relatively n00b trying to set up mythtv and having issues
installing the hauppage hvr-1600 tuner/capture card.

When I run dmesg, I get the following:

[  117.013178]  a1ac5dc28d2b4ca78e183229f7c595ffd725241c [media] gspca
- sn9c20x: Change the exposure setting of Omnivision sensors
[  117.013183]  4fb8137c43ebc0f5bc0dde6b64faa9dd1b1d7970 [media] gspca
- sn9c20x: Don't do sensor update before the capture is started
[  117.013188]  c4407fe86d3856f60ec711e025bbe9a0159354a3 [media] gspca
- sn9c20x: Set the i2c interface speed
[  117.028665] cx18: Unknown symbol i2c_bit_add_bus (err 0)

Help.

Thanks,
H
