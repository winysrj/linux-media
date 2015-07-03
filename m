Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:32957 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbbGCOXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2015 10:23:05 -0400
Received: by ykdv136 with SMTP id v136so97049950ykd.0
        for <linux-media@vger.kernel.org>; Fri, 03 Jul 2015 07:23:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM_ZknV+AEpxbPkKjDo68kRq-5fg1b7p77s+gfF3XGLZS9Tvyg@mail.gmail.com>
References: <CAM_ZknV+AEpxbPkKjDo68kRq-5fg1b7p77s+gfF3XGLZS9Tvyg@mail.gmail.com>
Date: Fri, 3 Jul 2015 17:23:04 +0300
Message-ID: <CAM_ZknWEjUTy0btqFYhJvSJiAFV6uTJzB3ceZzEMxNkKHr2dTg@mail.gmail.com>
Subject: Re: tw5864 driver development, help needed
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, khalasa <khalasa@piap.pl>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 3, 2015 at 1:03 AM, Andrey Utkin
<andrey.utkin@corp.bluecherry.net> wrote:
> Hi! I am working on making a Linux driver for TW5864-based video&audio
> capture and encoding PCI boards. The driver is to be submitted for
> inclusion to Linux upstream.
> The following two links are links to boards available for buying:
> http://www.provideo.com.tw/web/DVR%20Card_TW-310.htm
> http://www.provideo.com.tw/web/DVR%20Card_TW-320.htm
> We possess one 8-port board and we try to make it play.
>
> http://whdd.org/tw5864/TW-3XX_Linux.rar - this is reference driver
> code. Overwhelmingly complicated IMO.
> http://whdd.org/tw5864/tw5864b1-ds.pdf - Datasheet.
> http://whdd.org/tw5864/TW5864_datasheet_0.6d.pdf - Another datasheet.
> These two differ in some minor points.
> https://github.com/krieger-od/linux - my work in progress on this, in
> drivers/staging/media/tw5864 directory. Derived from
> drivers/media/pci/tw68 (which is raw video capture card), defined
> reasonable part of registers, now trying to make device produce video
> capture and encoding interrupts, but cannot get any interrupts except
> GPIO and timer ones. This is currently the critical blocking issue in
> development.
> I hope that somebody experienced with similar boards would have
> quesswork on how to proceed.
> My work-on-progress code is dirty, so if you would agree to check that
> only if it will be cleaned up, please let me know.
>
> I am willing to pay for productive help.
>
> --
> Bluecherry developer.


Up... we are moving much slower than we expected, desperately needing help.

Running reference driver with Ubuntu 9 (with kernel 2.6.28.10) with
16-port card shows that the
reference driver fails to work with it correctly. Also that driver is
not complete, it requires your userland counterpart for usable
operation, which is far from being acceptable in production.

Currently what stops us with our driver is that "H264 encoding done"
interrupt doesn't repeat, and CRC checksums mismatch for the first
(and last) time this interrupt happens.
We do our best to mimic what the reference driver does, but we might
miss some point.

I suspect that my initialization of video inputs or board clock
configuration is insufficient or inconsistent with what device needs.

Our work in progress is located in
https://github.com/krieger-od/linux, directory
drivers/staging/media/tw5864

This is another request for expert help.
The time is very important for us now.

Thanks in advance and sorry for distraction.

-- 
Bluecherry developer.
