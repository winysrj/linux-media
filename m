Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3Hc4Th007734
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 12:38:05 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3HZNh6032477
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 12:36:36 -0500
Received: by ey-out-2122.google.com with SMTP id 4so781364eyf.39
	for <video4linux-list@redhat.com>; Mon, 03 Nov 2008 09:36:36 -0800 (PST)
Message-ID: <30353c3d0811030936n744a55b2hb33b9300a4030106@mail.gmail.com>
Date: Mon, 3 Nov 2008 12:36:36 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <1225733048.20921.11.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
	<20081028180552.GA2677@tux>
	<30353c3d0810291008mc73e3ady3fdabc5adc0eacd5@mail.gmail.com>
	<30353c3d0810291012y5c9a4c54x480fdb0fa807dd0c@mail.gmail.com>
	<1225728173.20921.6.camel@tux.localhost>
	<30353c3d0811030819k4e6610d6u4188b940a40b02f5@mail.gmail.com>
	<1225733048.20921.11.camel@tux.localhost>
Cc: video4linux-list@redhat.com
Subject: Re: [patch] radio-mr800: remove warn- and err- messages
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

Looks good, but still missing one small detail. Set the ".name"
attribute/member of the usb_driver struct to the MR800_DRIVER_NAME
macro. This makes renaming the driver and updating the messages a
simple modification of the MR800_DRIVER_NAME macro.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
