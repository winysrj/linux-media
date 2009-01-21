Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0LJBbP6023947
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 14:11:37 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0LJBDax017757
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 14:11:13 -0500
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n0LJB7oT026290
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 13:11:12 -0600
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id n0LJB7Is014560
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 13:11:07 -0600 (CST)
From: "Curran, Dominic" <dcurran@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Wed, 21 Jan 2009 13:11:06 -0600
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B501290FAB33@dlee07.ent.ti.com>
In-Reply-To: <200901211053.56773.laurent.pinchart@skynet.be>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: RE: Appropriate interface ?
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


> > The EEPROM is written with factory settings (sensor & lens info).
> > It is meant to be read-only.
> >
> > Can anyone suggest an appropriate interface to usermode for the EEPROM ?
> > Should I implement sysfs interface ?
> > Or is there something more appropriate.
>
> The drivers/i2c/chips/at24.c driver, which should handle most EEPROMs, exports
> EEPROM data through sysfs.
>

Ok I see.
Is there a board file that already has this enabled, so I can use as example.

I grepped omap-linux kernel but didn't see anything.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
