Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOAvC9W006446
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 05:57:12 -0500
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOAv0ho005994
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 05:57:00 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Gilles Curchod <mailing@glorfindel.ch>
In-Reply-To: <492A84DA.4080409@glorfindel.ch>
References: <492A84DA.4080409@glorfindel.ch>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 24 Nov 2008 11:43:54 +0100
Message-Id: <1227523434.1732.45.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: V4L error on Linux 2.6.22
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

On Mon, 2008-11-24 at 11:41 +0100, Gilles Curchod wrote:
> Hi,

Hi Gilles,

	[snip]
> I have a Logitech Webcam (id 046d:08ad). The i.MX31 boards run Linux
> 2.6.22.6.
> I installed the GSPCA (gspcav1-20071224) drivers and I god the following
> message while starting the GSPCA module:
	[snip]

You should not use the gspca v1. It is not maintained anymore. The new
gspca driver is in the kernel version 2.6.27, but you may get it from
mercurial repositories at LinuxTv.org. Don't forget to read the
gspca_README in my page.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
