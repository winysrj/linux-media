Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:65028 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbZJASpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 14:45:04 -0400
Received: by vws30 with SMTP id 30so221989vws.21
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2009 11:45:08 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Oct 2009 15:38:35 -0300
Message-ID: <c85228170910011138w6d3fa3adibbb25d275baa824f@mail.gmail.com>
Subject: How to make my device work with linux?
From: Wellington Terumi Uemura <wellingtonuemura@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone!

I've a ISDB-Tb device from TBS-Tech that doesn't work with linux yet,
it uses this chip sets:
http://www.linuxtv.org/wiki/index.php/TBS_USB_ISDB-T_Stick

Tuner - NXP TDA18271HD
Demodulator - Fujitsu_MB86A16
USB interface - Cypress Semiconductor EZ-USB FX2LP CY7C68013A
Other - Shenzen First-Rank Technology T24C02A EEPROM 256 x 8 (2K bits)

Using information available on the internet I've dumped the required
firmware from the driver files using dd:
http://www.4shared.com/file/136823880/6c2d23d9/TBS-Techfw.html

As the linuxtv wiki shows, linux detect the device but to make it work
I think is a hole different issue because is not just place the
firmware in to the right place, the kernel have to know what to do
with it and how to interface with the device. I was playing with
fx2pipe trying to load the firmware and program returns that there is
no device connected to any USB ports and I don't know if this is the
right tool to play with.

I hope to find some light on this issue.

Thank you.
