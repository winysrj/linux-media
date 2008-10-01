Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m918LI9h011123
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 04:21:18 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m918L6dR019202
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 04:21:06 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
In-Reply-To: <62e5edd40810010028yba5fa91m6acaf93d3662acb8@mail.gmail.com>
References: <48E273C3.5030902@gmail.com> <48E320F0.6030002@hhs.nl>
	<62e5edd40810010028yba5fa91m6acaf93d3662acb8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 01 Oct 2008 10:08:47 +0200
Message-Id: <1222848527.1756.28.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, m560x-driver-devel@sourceforge.net
Subject: Re: [PATCH]Add support for the ALi m5602 usb bridge
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

On Wed, 2008-10-01 at 09:28 +0200, Erik Andrén wrote:

> 2008/10/1 Hans de Goede <j.w.r.degoede@hhs.nl>
>         Erik Andrén wrote:
>                 This patch adds support for the ALi m5602 usb bridge
>                 and is based on the gspca framework.
>                 It contains code for communicating with 5 different
>                 sensors:
>                 OmniVision OV9650, Pixel Plus PO1030, Samsung S5K83A,
>                 S5K4AA and finally Micron MT9M111.
	[snip]

>         Jean François, can you pick this up and feed it to Mauro
>         through the gspca tree?

Done.

Erik, I changed your name in the sources ('é' to 'e'). If you want it
back, it must be UTF-8 encoded...

Thank you very much for this driver.

BTW, I am waiting for the m5603c subdriver from Franck Bourdonnec. Did
you find common routines?

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
