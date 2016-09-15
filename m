Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44202 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1753482AbcIOTiB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 15:38:01 -0400
Date: Thu, 15 Sep 2016 15:37:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
cc: Wade Berrier <wberrier@gmail.com>, Sean Young <sean@mess.org>,
        <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: mceusb xhci issue?
In-Reply-To: <Pine.LNX.4.44L0.1607121150390.1900-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1609151529270.1396-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro:

I just took a look at the mceusb.c source file under drivers/media/rc/.  
The probe routine checks that ep_in != NULL, but it doesn't check
ep_out.  This can lead to a NULL-pointer dereference later on, crashing
the driver.  Such a crash was reported here:

	http://marc.info/?l=mythtv-users&m=144131333703197&w=2

You should a check for ep_out to the probe routine.

Alan Stern

