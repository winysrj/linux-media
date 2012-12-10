Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35578 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2LJQex (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 11:34:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Ti6Jr-0002jh-SO
	for linux-media@vger.kernel.org; Mon, 10 Dec 2012 17:35:03 +0100
Received: from 41.164.8.114 ([41.164.8.114])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 17:35:03 +0100
Received: from domelevo by 41.164.8.114 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 17:35:03 +0100
To: linux-media@vger.kernel.org
From: "Jean-Baka Domelevo Entfellner" <domelevo@gmail.com>
Subject: integrated webcam on Dell Latitude E6530 (Microdia)
Date: Mon, 10 Dec 2012 18:27:49 +0200
Message-ID: <op.wo3z0niik0ul61@makarska.sanbi.ac.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello the list,

I am not sure I post this in the appropriate list, but it looks like... I  
apologize if I'm wrong.

I am running Debian sid on a Linux 3.6.6 kernel on my Dell Latitude E6530.  
Its builtin camera appears to be Microdia, this is what lsusb says.  
Briefly:

   idVendor           0x0c45 Microdia
   idProduct          0x648b
   bcdDevice           28.07
   iManufacturer           2 CNFB183I412010000ML2
   iProduct                1 Laptop_Integrated_Webcam_E4HD

When I grep /var/log/kern.log for any line related to this stuff, nothing  
shows. In my kernel the support for "V4L USB devices" is built-in, and  
inside this I built "USB Video Class (UVC)" as a module, and the "GSPCA  
based webcams" are also as modules. Maybe you know which type of hardware  
is my Camera, and then help me...?

FYI, Carlo Hamalainenen recenlty reported  
(http://carlo-hamalainen.net/blog/2012/11/12/debian-on-dell-latitude-e6530/)  
that the same camera was working just fine with a 3.2.33 but not on his  
3.6.6 kernel.

Thanks!

JB

(I'm using this integrated Opera newsreader for the first time, can't  
figure out which address it will use as a sender address, but in case  
something weird happens, my address is domelevo at gmail.)


-- 
Using Opera's mail client: http://www.opera.com/mail/

