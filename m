Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:54088 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZCFDNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 22:13:08 -0500
Received: by wf-out-1314.google.com with SMTP id 28so293460wfa.4
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 19:13:05 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Mar 2009 12:13:05 +0900
Message-ID: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
Subject: About the radio-si470x driver for I2C interface
From: Joonyoung Shim <dofmind@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have worked with Silicon Labs Si4709 chip using the I2C interface.
There is the radio-si470x driver in linux-kernel, but it uses usb interface.

First, i made a new file based on radio-si470x.c in driver/media/radio/ for
si4709 i2c driver and modified it to use i2c interface instead of usb
interface and could listen to FM radio station.

I think it can be to join two things together to one file because there isn't
the difference between the two except for the interface.
I am considering how to integrate them.

Please send your opinion.


-- 
- Joonyoung Shim
