Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6GFvBoo023850
	for <video4linux-list@redhat.com>; Thu, 16 Jul 2009 11:57:11 -0400
Received: from mailgw2.jenoptik.com (mailgw2.jenoptik.com [213.248.109.130])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6GFuv65021030
	for <video4linux-list@redhat.com>; Thu, 16 Jul 2009 11:56:58 -0400
Received: from hermes.jena-optronik.de (hermes [10.128.0.8])
	by julia.jena-optronik.de (Postfix) with ESMTP id 45BB72102B
	for <video4linux-list@redhat.com>;
	Thu, 16 Jul 2009 17:56:56 +0200 (CEST)
Received: from hermes.jena-optronik.de (localhost.localdomain [127.0.0.1])
	by hermes.jena-optronik.de (8.13.8/8.13.8) with ESMTP id n6GFuuqd030950
	for <video4linux-list@redhat.com>; Thu, 16 Jul 2009 17:56:56 +0200
Date: Thu, 16 Jul 2009 17:56:42 +0200
From: "Jesko Schwarzer" <jesko.schwarzer@jena-optronik.de>
To: <video4linux-list@redhat.com>
Message-ID: <"4430.36481247759815.hermes.jena-optronik.de*"@MHS>
In-Reply-To: <20090716124506.26e7e6b0@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
 	charset="US-ASCII"
Content-Disposition: inline
Subject: Force driver to load (tcm825x)
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

Hello,

I am working to get the omap34xxcam with the tcm825x running. Currently I
was not successful in forcing the driver to load and register (in absence of
a real sensor). I do a probe when the driver starts and uncommented the i2c
things.

It fails when calling the

vidioc_int_g_priv()

Function in the device-register function of the "omap34xxcam.c".
How do I get it accepting the data ?

Is there any documentation to find?

Any hint would be perfect.

Kind regards
/Jesko

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
