Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33481 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbcBBWmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2016 17:42:32 -0500
Received: by mail-qg0-f42.google.com with SMTP id b35so2839550qge.0
        for <linux-media@vger.kernel.org>; Tue, 02 Feb 2016 14:42:32 -0800 (PST)
Received: from weboffice (dial-216-221-42-6.mtl.aei.ca. [216.221.42.6])
        by smtp.gmail.com with ESMTPSA id g189sm1745777qhg.2.2016.02.02.14.42.31
        for <linux-media@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 02 Feb 2016 14:42:31 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 02 Feb 2016 17:42:35 -0500
To: linux-media@vger.kernel.org
Subject: stk1160 and ARM Motion:  Error setting pixel format
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Zamar Ac" <zamarac@gmail.com>
Message-ID: <op.yb79c9i5blxmey@weboffice>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys,

I'm trying to setup a composite video camera capture with EasyCap DC60  
USB2.0 capture device on Seagate DockStar running ArchLinux ARM, stk1160  
driver, and Motion. Can't get any pic, only errors, while it works perfect  
in Windows. Didn't try running on a Linux PC, since the task is to run it  
on Linux ARM.

Motion at start up gives:

Nov 27 19:03:00 alarm motion[435]: [1] Selected palette UYVY
Nov 27 19:03:00 alarm motion[435]: [1] Test palette UYVY (360x240)
Nov 27 19:03:00 alarm motion[435]: [1] Error setting pixel format  
VIDIOC_S_FMT: Device or resource busy
Nov 27 19:03:00 alarm motion[435]: [1] VIDIOC_TRY_FMT failed for format  
UYVY: Device or resource busy
Nov 27 19:03:00 alarm motion[435]: [1] Unable to find a compatible palette  
format.
Nov 27 19:03:00 alarm motion[435]: [1] ioctl (VIDIOCGCAP): Inappropriate  
ioctl for device
Nov 27 19:03:00 alarm motion[435]: [1] Could not fetch initial image from  
camera
Nov 27 19:03:00 alarm motion[435]: [1] Motion continues using width and  
height from config file(s)
Nov 27 19:03:00 alarm motion[435]: [1] Resizing pre_capture buffer to 1  
items
Nov 27 19:03:01 alarm motion[435]: [1] Started stream webcam server in  
port 8081

Any suggestions?
