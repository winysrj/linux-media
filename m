Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1QK9JZa020008
	for <video4linux-list@redhat.com>; Thu, 26 Feb 2009 15:09:19 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com
	(mk-filter-1-a-1.mail.uk.tiscali.com [212.74.100.52])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1QK8vvO019756
	for <video4linux-list@redhat.com>; Thu, 26 Feb 2009 15:08:58 -0500
From: "Mark Burton" <mj.burton@tiscali.co.uk>
To: <video4linux-list@redhat.com>
References: <20090226170042.A1E4C61CBC5@hormel.redhat.com>
Date: Thu, 26 Feb 2009 20:08:51 -0000
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAALR6HK1gY7tAkFD4nHyXL9zCgAAAEAAAANm8fLLecxRCiEdsYLdu2LgBAAAAAA==@tiscali.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20090226170042.A1E4C61CBC5@hormel.redhat.com>
Subject: Peak DVB-T USB device
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

I have just recently acquired a new DVB stick device PEAK 202344AGPK (See
http://www.amazon.co.uk/PEAK-DVB-T-DIGITAL-STICK-Electronics/dp/B0010KI5SI).

This device is an Afatech based device, and marked on the PCB it has DVB-T
395U Rev D. This device seems to have the same PCB as the K-World DVB-T 395U
which is a supported device, but it has a different USB ID (1b80:e395) to
the K-World device.

By modifying the value of USB_PID_KWORLD_399U to 0xe395 in the file
dvb-usb-ids.h the device seems to work well with MythTV, although the remote
control does not seem to be recognised.

Would it be possible for somebody to add in to the code support for this
device ? I'd be happy to do some testing and confirm operation.

Thanks

Mark

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
