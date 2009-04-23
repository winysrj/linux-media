Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3N7f674030209
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 03:41:06 -0400
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3N7enTp027964
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 03:40:51 -0400
Message-ID: <17ad01c9c3e8$f38ea290$c80211ac@pcflorian3>
From: "Florian PANTALEAO" <fpantaleao@mobisensesystems.com>
To: <video4linux-list@redhat.com>, <judith.baumgarten@freenet.de>
References: <E1LwbZl-00027n-E5@www3.emo.freenet-rz.de>
Date: Thu, 23 Apr 2009 09:56:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: setting values to CICR2 register in PXA320 Quick Capture
	Interface
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



> Hi,
>
> I want to set various parameters in the Quick Capture Interface for a
PXA320 processor. I think, I found a way to do this, for resolution and
pixel clock parameters, but there is no way to set the parameters of CICR2
using the actual pxa_camera driver. It seems the driver  just implements the
master mode, and I wondered why. Is it not usefull to run a pxa_camera in
slave mode?
>
> Nevertheless. CICR2 contains also the BLW (Beginning-of-Line Pixel Clock
Wait Count) parameter, which is used in master and slave mode. So I
wondered, why there isn't a way to set it (Or have I just missed it?).

Quick Capture interface in PXA3xx has significantly evolved over PXA27x. I
remember a discussion in this list a couple of months ago about it.
Suggestion was to create a separate pxa3xx_camera driver because of these
differences.

Florian

> Here some extra information: I use V4L2 in combination with soc_camera
interface and a PXA320 host. The soc_camera interface and pxa_camera driver
are out of the 2.6.29 kernel.
>
> Thanks
> Judith
>
>
>
>
>
>
>
> #adBox3 {display:none;}
>
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
