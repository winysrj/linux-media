Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34283 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbbFBWDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 18:03:49 -0400
Received: by oifu123 with SMTP id u123so136740688oif.1
        for <linux-media@vger.kernel.org>; Tue, 02 Jun 2015 15:03:48 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 3 Jun 2015 01:03:48 +0300
Message-ID: <CAM_ZknV+AEpxbPkKjDo68kRq-5fg1b7p77s+gfF3XGLZS9Tvyg@mail.gmail.com>
Subject: tw5864 driver development, help needed
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, khalasa <khalasa@piap.pl>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi! I am working on making a Linux driver for TW5864-based video&audio
capture and encoding PCI boards. The driver is to be submitted for
inclusion to Linux upstream.
The following two links are links to boards available for buying:
http://www.provideo.com.tw/web/DVR%20Card_TW-310.htm
http://www.provideo.com.tw/web/DVR%20Card_TW-320.htm
We possess one 8-port board and we try to make it play.

http://whdd.org/tw5864/TW-3XX_Linux.rar - this is reference driver
code. Overwhelmingly complicated IMO.
http://whdd.org/tw5864/tw5864b1-ds.pdf - Datasheet.
http://whdd.org/tw5864/TW5864_datasheet_0.6d.pdf - Another datasheet.
These two differ in some minor points.
https://github.com/krieger-od/linux - my work in progress on this, in
drivers/staging/media/tw5864 directory. Derived from
drivers/media/pci/tw68 (which is raw video capture card), defined
reasonable part of registers, now trying to make device produce video
capture and encoding interrupts, but cannot get any interrupts except
GPIO and timer ones. This is currently the critical blocking issue in
development.
I hope that somebody experienced with similar boards would have
quesswork on how to proceed.
My work-on-progress code is dirty, so if you would agree to check that
only if it will be cleaned up, please let me know.

I am willing to pay for productive help.

-- 
Bluecherry developer.
