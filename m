Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA7BwLx0016894
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 06:58:22 -0500
Received: from namebay.info (mail.namebay.info [80.247.68.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA7Bw9O4014537
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 06:58:10 -0500
Received: from localhost by namebay.info (MDaemon PRO v9.6.2)
	with ESMTP id md50003740607.msg
	for <video4linux-list@redhat.com>; Fri, 07 Nov 2008 12:58:06 +0100
Message-ID: <20081107130136.fkdeaklvs40ocsws@webmail.hebergement.com>
Date: Fri, 07 Nov 2008 13:01:36 +0100
From: fpantaleao@mobisensesystems.com
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: About CITOR register value for pxa_camera
Reply-To: fpantaleao@mobisensesystems.com
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

On Fri, 7 Nov 2008, g.liakhovetski@gmx.de wrote:

> On Fri, 7 Nov 2008, fpantaleao@mobisensesystems.com wrote:
>
> > To be more general (sensor clocked by MCLK or not), I think we  
> should request
> > the sensor its PCLK, by adding a get_pclk member in soc_camera_ops for
> > example.
>
> Yes, that should be even better, and pass master-clock frequency as  
> a parameter? What shall we take for default? pclk == mclk or some  
> safe conservative value? Don't think requiring every camera driver  
> to provide this method would be very good.

MCLK as a parameter is fine.
For the default, I suggest:
   PCLK = MCLK when MCLK is enabled,
   13MHz otherwise which is a low value for PCLK.

I agree we must keep things simple even if a correct value for CITOR  
really improves acquisition performance.

>
> Another question, are there situations, when a sensor might decide  
> to change its pixelclock dynamically? Then it might need to inform  
> the host driver about the change?

PCLK changes dynamically with sensor resolution, subsampling, pixel  
format and so on. Every time a format change occurs, CITOR could be  
updated in 2 steps:
1. PCLK value should be updated by the camera driver.
The computation is based on the sensor input clock (provided by  
platform data) and current settings.
To make things more simple, the camera driver can use a constant equal  
to the lowest possible value.
2. PCLK value should be read to compute the new CITOR value.

Best regards.

Florian


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
