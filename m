Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4AMS9bJ003130
	for <video4linux-list@redhat.com>; Sat, 10 May 2008 18:28:09 -0400
Received: from omta0101.mta.everyone.net (imta-38.everyone.net
	[216.200.145.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4AMRvVH021251
	for <video4linux-list@redhat.com>; Sat, 10 May 2008 18:27:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20080510152609.C0FB7D5F@resin13.mta.everyone.net>
Date: Sat, 10 May 2008 15:26:09 -0700
From: <jortega@listpropertiesnow.com>
To: <tsw@johana.com>
Cc: video4linux-list@redhat.com
Subject: Re: Information request (USB ID:EB1A:E305)
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

Hi Tom,

I'm by far no expert on this but you will need to check dmesg or the sys log file and attempt to find the card and what is being assigned to it. Have you already installed the dvb4 drivers? Do you know what device it's on, etc...

John

--- sdc695@yahoo.com wrote:

From: Tom Watson <sdc695@yahoo.com>
To: video4linux-list@redhat.com
Subject: Information request (USB ID:EB1A:E305)
Date: Sat, 10 May 2008 13:09:48 -0700 (PDT)

Hi...

I've got a KWorld "VS-PVR-TV 305U" which is a tuner that plugs into a usb (2.0)
port.  Its other spigot is a simple F connector that awaits an antenna.

I've looked for a driver under Linux, but there appears to be none.
Some details:
USB vendor: EB1A, eMPIA Technology, Inc.
USB device: E305, nothing recorded (yet).

Does anyone know if a driver for this device is around, or if a current one can
be adapted for use.  I can do lots of experiments if someone has specifics on
what to do.  I can send a full 'lsusb' if needed, but won't waste the lists
space right now.

Thanks,



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
