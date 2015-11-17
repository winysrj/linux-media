Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33721 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbKQW30 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 17:29:26 -0500
Received: by lfaz4 with SMTP id z4so15004015lfa.0
        for <linux-media@vger.kernel.org>; Tue, 17 Nov 2015 14:29:24 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 17 Nov 2015 22:29:24 +0000
Message-ID: <CABHjWt6-22p3369L7Zantc1vzFcghFiAtFWnavYz6LrSTxvmMw@mail.gmail.com>
Subject: FE_READ_STATUS blocking time
From: ozgur cagdas <ocagdas@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've recently started experimenting with a DVB-T usb stick and the
intent of this post is to understand if what I am seeing is expected
behaviour or not. Therefore, I am not providing any hw, kernel version
etc details at this point but quite happy to do so if required.

Right, I use the FE_SET_PROPERTY ioctl to tune the front end and then
after 200ms. I call the FE_READ_STATUS ioctl to check the lock status.
My original plan was to call this ioclt periodically until lock is
acquired however, even though the device is opened with the O_NONBLOCK
flag, this call blocks for around 500ms and instead of seeing FEC,
viterbi etc blocks locking in incremental steps, it returns when all
the blocks are locked. Once locked, the subsequent FE_READ_STATUS
calls do return within 30ms.

If I unplug the feed before tune, then, each FE_READ_STATUS blocks for
about 500ms.

I also tried using the 'poll' system call on the FE's fd with POLLIN
but when it returns POLLIN in revents, then again FE_READ_STATUS
blocks around 500ms on the first attempt.

So, is there a way to avoid the FE_READ_STATUS block or is it down to
the individual driver implementation?

Also, is there a better way of monitoring the 'lock' status?

Kind regards,

Oz
