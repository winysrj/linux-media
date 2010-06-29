Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47031 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0F2KMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 06:12:14 -0400
Received: by qwi4 with SMTP id 4so2093428qwi.19
        for <linux-media@vger.kernel.org>; Tue, 29 Jun 2010 03:12:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Jun 2010 18:12:13 +0800
Message-ID: <AANLkTil-iWbMyCkKYfjWUUjG95iGjbo_h-y1snt0D444@mail.gmail.com>
Subject: Question on uvcvideo driver's power management
From: Samuel Xu <samuel.xu.tech@gmail.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Question on uvcvideo driver's power management:
Q1: We found some USB material mentioned : Relationship between ACPI
Dx states and USB PM states (active/suspended) is orthogonal.
Suspend/resume might not effect device Dx state(e.g. D0/D1/D3). Is it
a correct statement for general usb device and uvcvideo usb device?
Q2: How to tell USB uvcvideo device’s ACPI Dx state. It seems lsusb
can’t tell us those info. (lspci works for PCI device’s Dx state)
Q3: How to tell USB uvcvideo device’s suspension state? will any query
via urb will cause resume of uvcvideo device?
Q4: should USB uvcvideo device driver response to do some
device-specific power action (e.g. device register writing) to put a
specific USB camera into low power state when responding to suspend
action? (I didn't find such device-specific power code inside uvcvideo
src code)
Q5: If Q4 is Yes, should device vendor respond for those device-specific code?

Thanks!
