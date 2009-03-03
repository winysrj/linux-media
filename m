Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:42564 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZCCTpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 14:45:10 -0500
Received: by ewy25 with SMTP id 25so2480966ewy.37
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2009 11:45:07 -0800 (PST)
Message-ID: <49AD88BF.30507@gmail.com>
Date: Tue, 03 Mar 2009 19:45:03 +0000
From: uTaR <utar101@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge NOVA-T 500 falls over after warm reboot
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Just thought I would report some unusual behaviour I am seeing on my
Nova-T 500.  Basically the card works fine with a cold boot but falls
over rapidly after a warm reboot.

This started after I compiled the latest v4l source tree (as at 22 Feb
09) due to me adding a Tevii S650 to my system.  At first I thought it
was the Tevii which was causing the problem but testing showed the Nova
falls over irrespective of if the Tevii is attached.

I'm running Ubuntu with 2.6.27-11 and I never had this issue with v4l
running "out of the box."

Sample of the log after the Nova falls over follows:

[  117.920002] ehci_hcd 0000:05:00.2: force halt; handhake f88f4c14
00004000 00000000 -> -110
[  129.412342] mt2060 I2C write failed
[  132.412253] mt2060 I2C write failed
[  133.713596] mt2060 I2C write failed
[  136.712264] mt2060 I2C write failed
[  138.004603] mt2060 I2C write failed
[  141.004564] mt2060 I2C write failed
[  147.177361] mt2060 I2C write failed
[  150.176124] mt2060 I2C write failed
[  171.026988] mt2060 I2C write failed
[  171.041701] mt2060 I2C write failed (len=2)
[  171.041824] mt2060 I2C write failed (len=6)
[  171.041922] mt2060 I2C read failed
