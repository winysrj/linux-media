Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6FEPVGi011966
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 10:25:31 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6FEOoJj015078
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 10:24:50 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KIlSR-00035O-08
	for video4linux-list@redhat.com; Tue, 15 Jul 2008 14:24:47 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 14:24:46 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 14:24:46 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Tue, 15 Jul 2008 17:24:39 +0300
Message-ID: <487CB327.1090207@teltonika.lt>
References: <20080715135618.GE6739@pengutronix.de>
	<20080715140141.GG6739@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20080715140141.GG6739@pengutronix.de>
Subject: Re: PATCH: soc-camera: use flag for colour / bw camera instead of
 module parameter
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

Sascha Hauer wrote:
> Also in -p1 fashion:
> 
> 
> Use a flag in struct soc_camera_link for differentiation between
> a black/white and a colour camera rather than a module parameter.
> This allows for having colour and black/white cameras in the same
> system.

IMO you should pass void *sensor_data in there. Just to be as generic as
possible, because you don't know what flags, functions and etc. you will
need for all other sensors in the world...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
