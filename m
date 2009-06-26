Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:60270 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZFZX0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 19:26:25 -0400
Received: by gxk26 with SMTP id 26so1454086gxk.13
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 16:26:27 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 27 Jun 2009 01:26:24 +0200
Message-ID: <258fc9820906261626l78d68470p173d7c10ccc88985@mail.gmail.com>
Subject: fix for unrecognized Haupauge WinTV Nova-T
From: Robert Millan <rbrt.bcn@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

My Haupauge WinTV Nova-T (USB) wasn't being properly recognized.  I
got these in dmesg when sending IR signals to it:

[  433.353038] dib0700: Unknown remote controller key: 1D  3  0  0

It seems the driver is trying to match the vendor field with 0x1E,
whereas 0x1D is not listed.

The following worked for me:

sed -i drivers/media/dvb/dvb-usb/dib0700_devices.c -e "s/{ 0x1e, /{ 0x1d, /g"
