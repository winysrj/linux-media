Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBH7nNVq032264
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 02:49:23 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBH7mJDm007637
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 02:48:19 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Lehel Kovach <lehelkovach@hotmail.com>
In-Reply-To: <BAY135-W526C1AC293891AC584A4B7BFF50@phx.gbl>
References: <BAY135-W47952C51F5ED0CAEE9809BFF50@phx.gbl>
	<1229421997.1745.23.camel@localhost>
	<BAY135-W526C1AC293891AC584A4B7BFF50@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 17 Dec 2008 07:44:10 +0100
Message-Id: <1229496250.1747.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: RE: quickcam express
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

On Tue, 2008-12-16 at 08:42 -0800, Lehel Kovach wrote:
> its  a logitech quickcam express -- the old one: model# 961121-0403
> 
> im using 0.6.6 i believe (the one with distroed with ubuntu 8.1).  

Bad answer! I want to know the vendor and product IDs and also which
Linux driver handles your webcam. Please do:
	lsusb
and
	dmesg | tail -20
after connecting the webcam.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
