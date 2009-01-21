Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0L0nRGo019389
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 19:49:27 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0L0nAE8026087
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 19:49:10 -0500
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n0L0n5oE018666
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 18:49:10 -0600
Received: from dlee75.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id n0L0n5bk026068
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 18:49:05 -0600 (CST)
From: "Curran, Dominic" <dcurran@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Tue, 20 Jan 2009 18:49:02 -0600
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B50128BC0919@dlee07.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89441DD73588@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Appropriate interface ?
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


Hi
I apologies for slightly off-topic question.

I have a camera which consists of three separate i2c slave devices on the same i2c bus:
 - sensor              (V4L2 interface)
 - piezo len driver    (V4L2 interface)
 - EEPROM (512 bytes)         ?

The EEPROM is written with factory settings (sensor & lens info).
It is meant to be read-only.

Can anyone suggest an appropriate interface to usermode for the EEPROM ?
Should I implement sysfs interface ?
Or is there something more appropriate.

Thanks
dom

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
