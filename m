Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58EMwSh030508
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 10:22:58 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m58EMkie020892
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 10:22:46 -0400
Date: Sun, 8 Jun 2008 16:22:20 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: gsembox-v4l@yahoo.it
Message-ID: <20080608142220.GA314@daniel.bse>
References: <493332.13184.qm@web27606.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493332.13184.qm@web27606.mail.ukl.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: Problems with UCC4 Diginet video card (bt878 based)
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

On Sun, Jun 08, 2008 at 01:25:23PM +0000, gsembox-v4l@yahoo.it wrote:
> I see that it is similar to the ProVideo PV143 [card=105,insmod option]
> and I append the following line in the modprobe.conf file:
> 
> options bttv card=105

> I reboot and I see that the first card is good configured, the second is loaded as generic card,

> As you can see it looses 80 sec to autodetect the card. 
> How can I see to speed the card recognition ?

options bttv card=105,105

> May you add this card to bttv-cards.c file ?

It can't be autodetected as the vendor didn't add a 0.15 euro serial
eeprom to the card.

There is reason to add it only if there is no other card entry with the same
video and audio input configuration.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
