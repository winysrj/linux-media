Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.oregonstate.edu ([128.193.15.36]:50013 "EHLO
	smtp2.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab0DNWJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 18:09:30 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.oregonstate.edu (Postfix) with ESMTP id C7A743C160
	for <linux-media@vger.kernel.org>; Wed, 14 Apr 2010 15:09:28 -0700 (PDT)
Received: from smtp2.oregonstate.edu ([127.0.0.1])
	by localhost (smtp.oregonstate.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8qOYSv4m83dO for <linux-media@vger.kernel.org>;
	Wed, 14 Apr 2010 15:09:28 -0700 (PDT)
Received: from laddie.nws.oregonstate.edu (laddie.nws.oregonstate.edu [10.192.126.78])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp2.oregonstate.edu (Postfix) with ESMTPSA id 9B05D3C11E
	for <linux-media@vger.kernel.org>; Wed, 14 Apr 2010 15:09:28 -0700 (PDT)
Message-ID: <4BC63D1D.60706@onid.orst.edu>
Date: Wed, 14 Apr 2010 15:09:33 -0700
From: Michael Akey <akeym@onid.orst.edu>
MIME-Version: 1.0
To: Linux Media <linux-media@vger.kernel.org>
Subject: CPiA cam problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an old Ezonics EZCam P10U that I dug up and tried to get 
working.. but wasn't able to get any video from it.  dmesg and relevant 
VLC messages below.  Tested on Debian linux kernel 2.6.32-3-amd64.  Am I 
doing something wrong?  Those cpia error messages don't look too 
happy..  VLC gives the same error when testing on Windows XP.  Is my 
camera dead?

dmesg:
[76283.900014] usb 8-1: new full speed USB device using uhci_hcd and 
address 2
[76284.069063] usb 8-1: New USB device found, idVendor=0553, idProduct=0002
[76284.069067] usb 8-1: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0
[76284.069070] usb 8-1: Product: USB Camera
[76284.069175] usb 8-1: configuration #1 chosen from 1 choice
[76284.104794] Linux video capture interface: v2.00
[76284.115534] V4L-Driver for Vision CPiA based cameras v1.2.3
[76284.115536] Since in-kernel colorspace conversion is not allowed, it 
is disab
led by default now. Users should fix the applications in case they don't 
work wi
thout conversion reenabled by setting the 'colorspace_conv' module 
parameter to
1
[76284.116615] USB driver for Vision CPiA based cameras v1.2.3
[76284.116634] USB CPiA camera found
[76284.197067] cpia data error: [8] len=0, status=FFFFFFEE
[76284.197070] cpia data error: [9] len=0, status=FFFFFFEE
[76284.197072] cpia_usb_complete: usb_submit_urb ret -2
[76284.197077] cpia data error: [0] len=0, status=FFFFFFEE
[76284.197079] cpia data error: [1] len=0, status=FFFFFFEE
[76284.197081] cpia data error: [2] len=0, status=FFFFFFEE
[76284.197083] cpia data error: [3] len=0, status=FFFFFFEE
[76284.197085] cpia data error: [4] len=0, status=FFFFFFEE
[76284.197087] cpia data error: [5] len=0, status=FFFFFFEE
[76284.197088] cpia data error: [6] len=0, status=FFFFFFEE
[76284.197090] cpia data error: [7] len=0, status=FFFFFFEE
[76284.197092] cpia data error: [8] len=0, status=FFFFFFEE
[76284.197094] cpia data error: [9] len=0, status=FFFFFFEE
[76284.197096] cpia_usb_complete: usb_submit_urb ret -2
[76284.938150]   CPiA Version: 1.30 (2.10)
[76284.938153]   CPiA PnP-ID: 0553:0002:0100
[76284.938155]   VP-Version: 1.0 0141
[76284.938179] usbcore: registered new interface driver cpia


vlc complaining:
[0x12ad758] v4l2 demux debug: Trying direct kernel v4l2
[0x12ad758] v4l2 demux debug: opening device '/dev/video0'
[0x12ad758] v4l2 demux error: cannot get video capabilities (Invalid 
argument)
[0x12ad758] v4l2 demux debug: Trying libv4l2 wrapper
[0x12ad758] v4l2 demux debug: opening device '/dev/video0'
libv4l2: error getting capabilities: Invalid argument
[0x12ad758] v4l2 demux error: cannot get video capabilities (Invalid 
argument)
[0x12ad758] main demux warning: no access_demux module matching "v4l2" 
could be loaded
(... it goes on like that a few more times.)

Thank you for your help,

--Mike Akey
