Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57338 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0BWQMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 11:12:16 -0500
Received: by bwz1 with SMTP id 1so1101865bwz.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 08:12:15 -0800 (PST)
From: Abhijit Bhopatkar <bain@devslashzero.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Hauppague WinTV USB2-stick (tm6010)
Date: Tue, 23 Feb 2010 21:42:07 +0530
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002232142.07782.bain@devslashzero.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am unfortunate enough to have a above mentioned tuner card.
The windows driver is hcw66xxx.sys

According to various posts on this (and old v4l) mailing list, the driver i 
need is tm6000. However the device id for this tuner is 2040:6610

Only 2040:6600 seems to be recogised by the kernel driver.

I am already downloading the latest git trees and i find the driver existing in 
drivers/staging 

Is it worth for me to test this latest tree and driver against my card by just 
adding the device ids? 
If the devs need some more testing / help i can certainly volunteer my 
time/efforts. 
I do have fare familiarity with linux driver development and would be happy to 
help in debugging/developing support for this tuner. The only thing i don't 
have is knowledge for making this chipset work.

Abhijit
