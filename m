Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGIjmI2030680
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 13:45:48 -0500
Received: from smtp128.rog.mail.re2.yahoo.com (smtp128.rog.mail.re2.yahoo.com
	[206.190.53.33])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAGIjYvh022594
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 13:45:34 -0500
Message-ID: <49206A4C.6080602@rogers.com>
Date: Sun, 16 Nov 2008 13:45:32 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <491CC096.7090107@rogers.com>	
	<f3ae23390811140559i5e235c3bvabe8d5004d57165@mail.gmail.com>	
	<4920603D.20906@rogers.com>
	<412bdbff0811161016w91fc6c1s67e84519e2505b05@mail.gmail.com>
In-Reply-To: <412bdbff0811161016w91fc6c1s67e84519e2505b05@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: AVerMedia EZMaker USB Gold
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

Devin Heitmueller wrote:
> Yes.  I am working on getting the datasheet for this device, and will
> definitely be doing driver support for it (unless somebody manages to
> beat me to it).  It's good to know what other devices are using this
> chip, so I can pick one up and make sure I don't do anything that is
> specific to the Pinnacle 808e.
>
> Regards,
>
> Devin
>   

Hi Devin,

Janneg's device was either one of the DA-1N1 devices. 
(http://www.vistaview.tv/product-list.html)
Looking at the pics, I now recall that the interesting thing about the
7136 in that case is that it isn't the bridge, just the decoder ... and
the whole new can of worms on those cards are the respective Vixs
(encoder and bridge) chips - PCI or PCIe variant - for which there is no
support .

 

 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
