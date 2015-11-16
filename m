Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbbKPSRO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 13:17:14 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id C31D0C027326
	for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 18:17:13 +0000 (UTC)
From: Vladis Dronov <vdronov@redhat.com>
To: linux-media@vger.kernel.org
Cc: Vladis Dronov <vdronov@redhat.com>
Subject: Re: [PATCH] usbvision fix overflow of interfaces array
Date: Mon, 16 Nov 2015 19:16:54 +0100
Message-Id: <1447697814-18543-1-git-send-email-vdronov@redhat.com>
In-Reply-To: <1445946694-2931-1-git-send-email-oneukum@suse.com>
References: <1445946694-2931-1-git-send-email-oneukum@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Oliver, all.

Unfortunately, there are at least 4 different concerns about this patch:

1) "!dev->actconfig->interface[ifnum]" won't catch a case where the value is not
NULL but some garbage. This way the system may crash with "general protection fault"
later. I've hit this case during my tests.

2) "(ifnum >= USB_MAXINTERFACES)" does not cover all the error conditions. "ifnum"
should be compared to "dev->actconfig->desc.bNumInterfaces". I.e. compared to the
number of "struct usb_interface" kzalloc()-ed, not to USB_MAXINTERFACES.

3) If returned like this ("return -ENODEV;") there is a "usb_device" leak. There is
usb_get_dev() in the first line of usbvision_probe() but no usb_put_dev() on this
failure path. Commit "afd270d1" addresses exactly this case in other failure paths.

4) There is a bug of the same type several lines below with number of endpoints. The
code is accessing hard-coded second endpoint ("interface->endpoint[1].desc") which
may not exist. It would be great to handle this in the same patch too.

I've just posted my version of the patch for the same issue to the list (subject:
"[media] usbvision: fix crash on detecting device with invalid configuration",
Message-Id: <1447696511-17704-2-git-send-email-vdronov@redhat.com>). I believe it
resolves all the above concerns.

Best regards,
Vladis Dronov | Red Hat, Inc.| Product Security Engineer
