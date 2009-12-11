Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55167 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbZLKPJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 10:09:50 -0500
Received: by bwz27 with SMTP id 27so663103bwz.21
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 07:09:56 -0800 (PST)
To: linux-media@vger.kernel.org
Subject: dib0700: Nova-T-500 remote - mixed button codes
From: Antonio Marcos =?utf-8?q?L=C3=B3pez_Alonso?=
	<amlopezalonso@gmail.com>
Reply-To: amlopezalonso@gmail.com
Date: Fri, 11 Dec 2009 15:09:51 +0000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912111509.51455.amlopezalonso@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I own a Hauppauge Nova-T-500 in a box running Mythbuntu 9.10. The card runs 
fine except when it comes to the in-built remote sensor: 

Whenever I press any button, the remote sensor seems to receive some other 
keycodes aside the proper one (i.e. when I press Volume Up button the sensor 
receives it most of the time, but sometimes it understands some other buttons 
are pressed like ArrowDown, Red button and so, making MythTV experience very 
annoying). There are only three buttons that are always well received with no 
confusion at all: "OK", "ArrowDown" and "Play". This behavior occurs with two 
identical remotes I own (one of them belonging to a WinTV HVR-1100) and 
another card user has reported a similar behavior with its own and same 
remote.

I tested both remotes with the HVR-1100 and they behave perfectly, so I guess 
this is not a remote related issue.

Though I have tried several LIRC setup files and swapped dvb_usb_dib0700 
firmware files (1.10 and 1.20 versions) they make no working difference at 
all.

I also tried rebuilding v4l-dvb code to no avail.

Any suggestions? I would gladly provide further info/logs upon request.

Cheers,
Antonio
