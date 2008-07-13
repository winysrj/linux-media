Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6DHpcIf017733
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 13:51:38 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6DHpRHZ013884
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 13:51:27 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1960475ywb.81
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 10:51:27 -0700 (PDT)
Message-ID: <b7b14cbb0807131051o7b3eb010oc5ca314eaff27edb@mail.gmail.com>
Date: Sun, 13 Jul 2008 19:51:27 +0200
From: "Clinton Lee Taylor" <clintonlee.taylor@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: [PATCH] uvcvideo: RESET_ON_TIMOUT Quirk ...
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

Greetings ...


>
> Subject: [PATCH] uvcvideo: RESET_ON_TIMOUT Quirk
> This patch provides another quirk that causes the driver to reset the
> device on -110.  This is a reworking of the patch provided by Michel Stempin
> in January.  I've tested it and it works for me with my Quickcam Orbit MP.
>  I'm not certain that it's a candidate for inclusion, especially in it's
> current state, but I thought I'd put it out there for others to try, and
> possibly make mainline worthy.
>
>
> Pat Erley
>
>
 I would like to second this patch, hoping that it might work around the
firmware bug in my Logitech QuickCam  Sphere ...

Thanks
Mailed
LeeT
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
