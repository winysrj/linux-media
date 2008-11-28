Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASAAsKv009881
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 05:10:54 -0500
Received: from smoke.redembedded.co.uk (mail.redembedded.co.uk
	[83.100.215.137])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASAAdV6003883
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 05:10:40 -0500
Received: from dhcp50.redembedded.com ([192.168.168.150])
	by smoke.redembedded.co.uk with esmtps
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.69)
	(envelope-from <darren.longhorn@redembedded.com>) id 1L60LO-0005FO-5G
	for video4linux-list@redhat.com; Fri, 28 Nov 2008 10:13:21 +0000
Message-ID: <492FC38B.6000703@redembedded.com>
Date: Fri, 28 Nov 2008 10:10:19 +0000
From: Darren Longhorn <darren.longhorn@redembedded.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <11380.62.70.2.252.1227781392.squirrel@webmail.xs4all.nl>	<20081127120814.14f25c1b@pedra.chehab.org>
	<200811271520.48202.laurent.pinchart@skynet.be>
In-Reply-To: <200811271520.48202.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: RFC: drop support for kernels < 2.6.22
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

Laurent Pinchart wrote:

> Before moving to linuxtv.org the UVC driver was backward compatible with all 
> kernels starting at 2.6.15 out of the box. With a minor patch applied this 
> even extended to 2.6.10. While I have no statistics regarding kernel versions 
> on which the UVC driver is used, the driver seems to be popular with embedded 
> users who usually run "old" vendor-supplied kernels on their systems.
> 
> As such, at least for the UVC driver, I'd hate to see compatibility with 
> 2.6.16-2.6.21 going away anytime soon.

As one of those embedded developers, I second this view.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
