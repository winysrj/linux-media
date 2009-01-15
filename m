Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FB8A9T025292
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 06:08:10 -0500
Received: from iamp03.mxsweep.com (mail150.ix.emailantidote.com
	[89.167.219.150])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0FB7emQ020072
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 06:07:41 -0500
Message-ID: <496F18C4.9020009@draigBrady.com>
Date: Thu, 15 Jan 2009 11:06:44 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
To: Robert Krakora <rob.krakora@messagenetsystems.com>
References: <b24e53350901141004v6a2ed7d7nb6765fa1d112f7ef@mail.gmail.com>
In-Reply-To: <b24e53350901141004v6a2ed7d7nb6765fa1d112f7ef@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2.6.27.8 1/1] em28xx: Fix audio URB transfer buffer
 memory leak and race condition/corruption of capture pointer
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

Robert Krakora wrote:
> em28xx: Fix audio URB transfer buffer memory leak and race
> condition/corruption of capture pointer
> 
> 
> Signed-off-by: Robert V. Krakora <rob.krakora@messagenetsystems.com>
> 
> diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-audio.c
> --- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
> 10:06:12 2009 -0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
> 12:47:00 2009 -0500
> @@ -62,11 +62,20 @@
>         int i;
> 
>         dprintk("Stopping isoc\n");
> -       for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> -               usb_unlink_urb(dev->adev.urb[i]);
> -               usb_free_urb(dev->adev.urb[i]);
> -               dev->adev.urb[i] = NULL;
> -       }
> +        for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> +               usb_unlink_urb(dev->adev.urb[i]);
> +               usb_free_urb(dev->adev.urb[i]);
> +               dev->adev.urb[i] = NULL;
> +               if (dev->adev.urb[i]) {
> +                       usb_unlink_urb(dev->adev.urb[i]);
> +                       usb_free_urb(dev->adev.urb[i]);
> +                       dev->adev.urb[i] = NULL;
> +               }
> +                if (dev->adev.transfer_buffer) {
> +                       kfree(dev->adev.transfer_buffer[i]);
> +                       dev->adev.transfer_buffer[i] = NULL;
> +               }
> +        }
> 
>         return 0;
>  }

That looks a bit incorrect. I fixed this last week in Markus'
repository, as I thought the leak was specific to that tree:
http://mcentral.de/hg/~mrec/em28xx-new/diff/1cfd9010a552/em28xx-audio.c

Pádraig.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
