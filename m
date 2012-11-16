Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52513 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2KPMma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 07:42:30 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so2717115oag.19
        for <linux-media@vger.kernel.org>; Fri, 16 Nov 2012 04:42:29 -0800 (PST)
Received: from [10.16.0.66] (chumley.hagood [10.16.0.66])
	by Deathwish.hagood (Postfix) with ESMTP id 9E8B5C7B8033
	for <linux-media@vger.kernel.org>; Fri, 16 Nov 2012 06:42:26 -0600 (CST)
Message-ID: <50A634B2.6010007@gmail.com>
Date: Fri, 16 Nov 2012 06:42:26 -0600
From: David Hagood <david.hagood@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: How to get the DVB drivers to stop spamming my logs?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a MythTV box with 3 tuners: 2 USB and one PCI. One or more of the 
tuners' drivers keeps spamming syslog with the following (taken from the 
Logwatch summary):

     lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == 
-71) ...:  278497 Time(s)
     lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x6e error (ret == 
-71) ...:  410252 Time(s)
     lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x8b error (ret == 
-71) ...:  1278 Time(s)
     lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00,  ...:  73945 
Time(s)
     lgdt330x: i2c_write_demod_bytes error (addr 4c <- 14,  ...:  1281 
Time(s)
     xc2028 1-0061: Error on line 1294: -71 ...:  1234 Time(s)

Is there any way to get the drivers to stop spamming syslog, short of 
recompiling them with the error messages removed?

