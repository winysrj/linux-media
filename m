Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4EBoP15001090
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 07:50:25 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4EBnxa6027231
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 07:49:59 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JwFUb-0004wR-F5
	for video4linux-list@redhat.com; Wed, 14 May 2008 11:49:57 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 11:49:57 +0000
Received: from augulis.darius by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 11:49:57 +0000
To: video4linux-list@redhat.com
From: Darius <augulis.darius@gmail.com>
Date: Wed, 14 May 2008 14:44:56 +0300
Message-ID: <482AD0B8.5050202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit
Subject: I2C interface problem with OmniVision OV7670
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

OV7670 does not support repeated start.
When sending several messages (read or write) in one transaction, 
repeated start is not accepted by OV7670. OV7670 thinks, that it is next 
clock pulse, not repeated start and second message is not acknowledged.
It is known bug of OV7670 or my i2c adapter driver works not correct?
When sending one byte, everything is ok.
It is interesting, how works OV7670 driver, written by Jonathan Corbet?
Because there are used i2c_smbus_write_byte_data() and 
i2c_smbus_read_byte_data() functions, which means, that in one 
transaction two messages are sent - register address (write) and read data.
For me this does not work, only register address is acknowledged by 
OV7670, and second message (read data) fails.

I want to know, is there possibility to use multi-message transactions 
or not?

BR,
Darius

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
