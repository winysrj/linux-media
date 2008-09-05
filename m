Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m856mQQS015891
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 02:48:26 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m856XhMW032657
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 02:33:50 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: "B. Bogart" <ben@ekran.org>
In-Reply-To: <48C06C3A.5000104@ekran.org>
References: <48C05DC8.5060700@ekran.org>
	<1220568687.2736.12.camel@morgan.walls.org>
	<48C06C3A.5000104@ekran.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 05 Sep 2008 08:01:27 +0200
Message-Id: <1220594487.1750.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, IOhannes m zmoelnig <zmoelnig@iem.at>
Subject: Re: V4l2 :: Debugging an issue with cx8800 card.
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

On Thu, 2008-09-04 at 16:16 -0700, B. Bogart wrote:
> I've not yet tried running your program, but did have some luck with:
> http://moinejf.free.fr/svv.c

Hello B.,

It seems the driver cannot switch to 640x480. You may know it grabbing
images with svv. Try
	svv -rg -f 640x480
then
	svv -rg -f 320x240
and check each time the size of image.dat.

Best regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
