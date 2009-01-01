Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01HcpJc026171
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 12:38:51 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01Hcbc6003132
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 12:38:37 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Adam Baker <linux@baker-net.org.uk>
In-Reply-To: <200901010033.58093.linux@baker-net.org.uk>
References: <200901010033.58093.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 01 Jan 2009 18:38:18 +0100
Message-Id: <1230831498.1702.40.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list <video4linux-list@redhat.com>,
	sqcam-devel@lists.sourceforge.net, kilgota@banach.math.auburn.edu
Subject: Re: [REVIEW] Driver for SQ-905 based cameras
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

On Thu, 2009-01-01 at 00:33 +0000, Adam Baker wrote:
> Theodore Kilgore and I now have a driver for cameras based on the 
> SQ 905 chipset that is capable of producing images. It is based on gspca
	[snip]

Fine, but...

+ * This driver has used as a base the finepix driver and other gspca
+ * based drivers and may still contain code fragments taken from those
+ * drivers.

You did not look carefully at the finepix subdriver. Its webcams work
quite the same as yours, i.e. they ask for a control message to start
the bulk image transfer and an other control message to ack the
reception of the image. For that, the finepix implements a state machine
running at interrupt level or in the system work queue. All USB
exchanges are asynchronous, so that the system thread is not blocked.
Instead, you do a loop in this thread: then, this one cannot be used for
any other purpose!

I see only one alternative to do the image transfer:
- either implement a state machine as it is done in finepix,
- or have a specific work queue to handle the USB exchanges.

Best regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
