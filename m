Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.cl.cam.ac.uk ([128.232.25.21]:45342 "EHLO
	mta1.cl.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbbDPJyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 05:54:24 -0400
Received: from dirac.cl.cam.ac.uk ([128.232.65.23])
	by mta1.cl.cam.ac.uk with esmtp (Exim 4.63)
	(envelope-from <Markus.Kuhn@cl.cam.ac.uk>)
	id 1YigKs-0007Vw-Pa
	for linux-media@vger.kernel.org; Thu, 16 Apr 2015 10:43:50 +0100
Message-ID: <552F8497.6010900@cl.cam.ac.uk>
Date: Thu, 16 Apr 2015 10:44:55 +0100
From: Markus Kuhn <Markus.Kuhn@cl.cam.ac.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: honestech VIDBOX NW07 (eMPIA EM28284)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've recently bought an "honestech VIDBOX for Mac pack"
which contains an "honestech VIDBOX NW07" analog video to
USB grabber device based on the eMPIA EM28284 chip. The only
other chip on the PCB is a 24C32WP 4 kB serial EEPROM.

USB ID = eb1a:5188

What is the status of Linux support for this device?

I've written up all information that I have about it so far at

   http://linuxtv.org/wiki/index.php/Honestech_Vidbox_NW07

including a PCB photo and lsusb -v output.

What can I do to help getting a Linux driver for it working?

Markus

http://www.honestech.com/main/DriverUpdates.asp#VIDBOXdrivers
http://www.honestech.com/main/VIDBOXforMac.asp

-- 
Markus Kuhn, Computer Laboratory, University of Cambridge
http://www.cl.cam.ac.uk/~mgk25/ || CB3 0FD, Great Britain
