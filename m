Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m71HKn1v013820
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 13:20:49 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m71HKaJN022108
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 13:20:37 -0400
Message-ID: <489347F6.60606@hhs.nl>
Date: Fri, 01 Aug 2008 19:29:26 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <1217502148.1710.14.camel@localhost>
In-Reply-To: <1217502148.1710.14.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: libv4l - decode to RGB24
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

Jean-Francois Moine wrote:
> Hello Hans,
> 
> May you add frame decoding to RGB24, this is the common pixelformat
> format of gtk and other graphical interfaces.
> 

Yes adding RGB24 support has crossed my mind, the problem is that each 
additional output format needs to be added to all convert routines, or we need 
to use an intermediate buffer, which is slow for no good reason.

So eventually I'll probably do this but atm I've other priorities. Patches welcome.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
