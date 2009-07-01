Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n61ASp6l010713
	for <video4linux-list@redhat.com>; Wed, 1 Jul 2009 06:28:51 -0400
Received: from mailgw2.jenoptik.com (mailgw2.jenoptik.com [213.248.109.130])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n61AScBH030419
	for <video4linux-list@redhat.com>; Wed, 1 Jul 2009 06:28:38 -0400
Received: from hermes.jena-optronik.de (hermes [10.128.0.8])
	by julia.jena-optronik.de (Postfix) with ESMTP id E93CB2102B
	for <video4linux-list@redhat.com>;
	Wed,  1 Jul 2009 12:28:36 +0200 (CEST)
Received: from hermes.jena-optronik.de (localhost.localdomain [127.0.0.1])
	by hermes.jena-optronik.de (8.13.8/8.13.8) with ESMTP id n61ASaqN008009
	for <video4linux-list@redhat.com>; Wed, 1 Jul 2009 12:28:36 +0200
Date: Wed, 1 Jul 2009 12:28:31 +0200
From: "Jesko Schwarzer" <jesko.schwarzer@jena-optronik.de>
To: "'V4L'" <video4linux-list@redhat.com>
Message-ID: <"4430.30631246444116.hermes.jena-optronik.de*"@MHS>
In-Reply-To: <b24e53350906300905k3d3d2141geb247736402dba10@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 	charset="US-ASCII"
Content-Disposition: inline
Subject: Newbe question: How are SOC cameras integrated ? How to connect an
	FPGA to the video interface ?
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

we currently use an OMAP Zoom board and want to connect an FPGA board to the
video interface.
One idea is to simulate an SOC camera like the MT9V022 device, but we don't
know exacly how it is managed to from driver view.
We use a 2.6.28 kernel and managed to integrate v4l2 and the SOC devices;
but we did not get an /dev/video device ...
And then, how to get a virtual MT9V022 running ? How to select ?

Thanks in advance
/Jesko

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
