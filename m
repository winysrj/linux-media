Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m997PucU012988
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 03:25:56 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m997PiT9017179
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 03:25:44 -0400
Received: by ey-out-2122.google.com with SMTP id 4so1262456eyf.39
	for <video4linux-list@redhat.com>; Thu, 09 Oct 2008 00:25:43 -0700 (PDT)
Date: Thu, 9 Oct 2008 17:27:06 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-dvb@linuxtv.org, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Message-ID: <20081009172706.68251375@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: ZL10353 config
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

Hi All

The ZL10353 is a DVB-T demod. It has internal I2C bus for a tuner.
If no any device on the second I2C bus switch ZL19353 internal I2C bridge to pass-thru mode
kill the main I2C bus. Main I2C bus has state BUSY all time.

For solve this problem I set checking no_tuner config of the ZL10353 chip. If no any tuners
don't switch ON I2C bridge.

Is this solution correct?? May be add new parametr second_bus_empty??

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
