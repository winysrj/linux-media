Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5REWnwk016370
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 10:32:57 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5REG4k7009760
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 10:17:10 -0400
Received: by fg-out-1718.google.com with SMTP id e21so292628fga.7
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 07:15:58 -0700 (PDT)
Message-ID: <30353c3d0806270715q3e3aae26y56d17f42bc70b18a@mail.gmail.com>
Date: Fri, 27 Jun 2008 10:15:58 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com
In-Reply-To: <20080627100023.00803c90@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080626231551.GA20012@kroah.com>
	<20080627100023.00803c90@gaivota>
Subject: Re: [PATCH] add Sensoray 2255 v4l driver
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

[snip]
>
> A last word is about the usage of locks at the driver. I suspect you would need
> to lock on almost all ioctl handlers. However, as we're currently protected by
> Kernel big lock, the code is ok. There are some proposed changes to move away
> from KBL. When this happen, we may need to review the locking schema.

Given that most drivers rely on the KBL being held, we could address
this issue in videodev driver rather than having to update all other
drivers. Granted it may not be ideal to do so, but it would buy some
time to update the drivers after the BLK is removed.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
