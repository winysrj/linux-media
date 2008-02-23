Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1NJqvOq012330
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 14:52:57 -0500
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1NJqPJi032483
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 14:52:25 -0500
Message-ID: <47C0794B.5070807@free.fr>
Date: Sat, 23 Feb 2008 20:51:39 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: "H. Willstrand" <h.willstrand@gmail.com>
References: <47BC8BFC.2000602@kaiser-linux.li>	
	<175f5a0f0802211212s104e4808wdab5c6806eb7849f@mail.gmail.com>	
	<47BDE1B9.4040309@kaiser-linux.li>	
	<200802212303.37379.laurent.pinchart@skynet.be>	
	<47BDF9BC.2030603@kaiser-linux.li> <47BE980E.4090900@free.fr>
	<175f5a0f0802221615j3d2ec239r2e35d7c14dc80a28@mail.gmail.com>
In-Reply-To: <175f5a0f0802221615j3d2ec239r2e35d7c14dc80a28@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: V4L2_PIX_FMT_RAW
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

H. Willstrand a écrit :
> Hi Thierry,
>
>   
[SNIP]
>
> Ok, so the idea is to make converting and decompression transparent
> for the application.
>
> Are there any plans to run the v4l2_helper as an shared object in the
> application process with a direct interface? (to avoid the
> kernel-to-user-space, user-to-kernel-space, kernel-to-user-space)
>
>   
Yes, this is the aim of the project; the final step I hope will show a
new library that will be used by applications, discussing directly with
the base drivers.
Please join to the v4l2-library mailing-list to discuss about the
implementation of the helper daemon in that way.
Following discussions about this specific subject will be easier!
Thanks,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
