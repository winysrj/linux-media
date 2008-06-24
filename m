Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5O7kEpd016191
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 03:46:14 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5O7jmEu019673
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 03:45:48 -0400
Date: Tue, 24 Jun 2008 09:45:21 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Andrew Chuah <hachuah@gmail.com>
Message-ID: <20080624074521.GB11578@daniel.bse>
References: <e18c2fef0806231913w2cab7de9yae74a9bdc7d04160@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e18c2fef0806231913w2cab7de9yae74a9bdc7d04160@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: BTTV autodetection code - need help understanding.
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

On Tue, Jun 24, 2008 at 10:13:48AM +0800, Andrew Chuah wrote:
> I am getting 0x00000000 for my cardid, which makes it skip the
> autodetection step. Does anyone have any idea why this is happening?

Old dmesg output in the list archive tells me that the GV250 does not
have the EEPROM necessary for autodetection.

> It shows up on lspci -nn as:
> 
> 03:01.0 Multimedia video controller [0400]: Brooktree Corporation
> Bt878 Video Capture [109e:036e] (rev 11)
> 03:01.1 Multimedia controller [0480]: Brooktree Corporation Bt878
> Audio Capture [109e:0878] (rev 11)

The Subsystem IDs used for autodetection only show up when you pass -v to
lspci. What you see are the PCI vendor and device IDs. These are the same
for all Bt878 cards.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
