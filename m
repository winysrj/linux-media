Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id o9VFC8Q1004204
	for <video4linux-list@redhat.com>; Sun, 31 Oct 2010 11:12:08 -0400
Received: from swip.net (mailfe05.swip.net [212.247.154.129])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9VFBmpi015865
	for <video4linux-list@redhat.com>; Sun, 31 Oct 2010 11:11:52 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: App Deb <appdebgr@gmail.com>
Subject: FYI: usb dvb-t tuner needs to be re-plugged (after boot/reboot) to
	work.
Date: Sun, 31 Oct 2010 15:13:50 +0100
References: <AANLkTi=P_yaotTvJz72O5hPNQc2h-DsaEdR4EqD6MohJ@mail.gmail.com>
	<201010301707.44939.hselasky@c2i.net>
	<AANLkTikPMLzfis2Kdozp6ruqwDSEVWhN1sBPHFArQn_H@mail.gmail.com>
In-Reply-To: <AANLkTikPMLzfis2Kdozp6ruqwDSEVWhN1sBPHFArQn_H@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201010311513.50130.hselasky@c2i.net>
Cc: freebsd-multimedia@freebsd.org, video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <video4linux-list@redhat.com>

Hi,

CC'ed video4linux-list@redhat.com on this issue. Maybe they have some 
comments?

It looks like the warm detection does not work for the "Gigabyte U8000-RH", 
and that the firmware has to be re-loaded, until the power is cut.

--HPS

On Saturday 30 October 2010 19:51:43 App Deb wrote:
> Nice,
> 
> I wasn't able to find something that links my usb idVendor/Product to
> cold/warm states (not very good comments and not much time), however in:
> 
> drivers/media/dvb/dvb-usb/dvb-usb-init.c
> 
> I found a line:
> 
> if (cold)
> 
> and replaced it with...
> 
> if (1)
> 
> and guess what, it works perfectly now, many thanks Hans.
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
