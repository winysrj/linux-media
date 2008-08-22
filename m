Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MBICQo014419
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 07:18:12 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.181])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MBI18V027475
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 07:18:01 -0400
Received: by wa-out-1112.google.com with SMTP id j32so369205waf.7
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 04:18:01 -0700 (PDT)
Message-ID: <7813ee860808220418j65dac22eme4336f24b137f970@mail.gmail.com>
Date: Fri, 22 Aug 2008 06:18:01 -0500
From: "Mark Ferrell" <majortrips@gmail.com>
To: "Theou Jean-Baptiste" <jbtheou@gmail.com>
In-Reply-To: <6f278f100808200335x2dc3b973hd2248573a73990b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <6f278f100808171248s53633e27xce36cbbf123c5e0a@mail.gmail.com>
	<6f278f100808171258r609757a0r1a605ffd9ddee0f1@mail.gmail.com>
	<20080818003448.GB22438@pippin.gateway.2wire.net>
	<6f278f100808180508k792b52f5x9e945ff08466f9e6@mail.gmail.com>
	<20080818162449.GC22438@pippin.gateway.2wire.net>
	<6f278f100808180953h3a0a7f8fl55c239b825566551@mail.gmail.com>
	<6f278f100808200335x2dc3b973hd2248573a73990b9@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

On Wed, Aug 20, 2008 at 5:35 AM, Theou Jean-Baptiste <jbtheou@gmail.com> wrote:
> With debug=4 option :
>
>
> [ 2150.623457] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
> [sccb_reg_write:308] sccb_reg_write failed
> [ 2150.623460] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
> [sccb_reg_write:302] reg: 0×0013, val: 0×00f0
> [ 2150.623463] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
> [ov534_reg_write:222] reg=0×00f2, val=00013
> [ 2150.623579] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
> [ov534_reg_write:222] reg=0×00f3, val=000f0
> [ 2150.623704] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
> [ov534_reg_write:222] reg=0×00f5, val=00037
> [ 2150.623953] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
> [ov534_reg_read:242] reg=0×00f6, data=0×0007
> [ 2150.623957] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
> [sccb_check_status:294] sccb status 0×07, attempt 1/5

It looks like the driver is failing to setup the sensor on the
Hercules Blog Webcam. I will need to see if I can reproduce this on my
end and try to figure out why this is happening.

--
Mark

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
