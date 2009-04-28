Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:58216 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbZD1CDj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 22:03:39 -0400
Received: by gxk10 with SMTP id 10so614182gxk.13
        for <linux-media@vger.kernel.org>; Mon, 27 Apr 2009 19:03:39 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Apr 2009 22:03:39 -0400
Message-ID: <412bdbff0904271903o6a66c48co87b8b1829be2f62f@mail.gmail.com>
Subject: Panic in HVR-950q caused by changeset 11356
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Janne Grunau <j@jannau.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Vincent Krakora <rob.krakora@gmail.com>,
	Josh Watzman <jwatzman@andrew.cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Janne,

Ok, so now I need to better understand the nature of changeset 11356.
It turns up I spent the entire afternoon debugging a kernel panic on
usb disconnect, which ended up being due to this patch:

au0828: use usb_interface.dev for v4l2_device_register
http://linuxtv.org/hg/v4l-dvb/rev/33810c734a0d

The change to pass the interface->dev to v4l2_device_register()
effectively overwrote the interface data, so while I thought
usb_set_intfdata() was storing the au0828_dev *, in fact it was
holding a v4l2_device *.  When au0828_usb_disconnect() eventually gets
called, the call to usb_get_intfdata() returned the v4l2_device, and
presto - instant panic.

So, either I can roll back this change, or I can make the call to
usb_set_intfdata() *after* the call to v4l2_device_register().
However, I don't know what else that might screw up (I haven't traced
out everything in v4l2-device that might expect a v4l2_device * to be
stored there).

Suggestions?

Perhaps if you could provide some additional background as to what
prompted this change, it will help me better understand the correct
course of action at this point.

Devin

cc: Robert Krakora and Josh Watzman since they both independently
reported what I believe to be the exact same issue (the stack is
slightly different because in their case as it crashed in the
dvb_unregister portion of the usb_disconnect routine).

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
