Return-path: <video4linux-list-bounces@redhat.com>
Date: Sat, 3 Jan 2009 22:43:51 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: "Robert Krakora" <rob.krakora@messagenetsystems.com>
Message-ID: <20090103224351.0276d1d5@gmail.com>
In-Reply-To: <b24e53350901031059w53da1bb9j54c2e89a4bd0dfed@mail.gmail.com>
References: <b24e53350812311623qbf8a501re86303fb0fd9ef5c@mail.gmail.com>
	<b24e53350901031059w53da1bb9j54c2e89a4bd0dfed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jerry Geis <geisj@messagenetsystems.com>, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: em28xx-audio.c memory leak and kill URB function call missing?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Hello Robert,

On Sat, 3 Jan 2009 12:59:57 -0600
"Robert Krakora" <rob.krakora@messagenetsystems.com> wrote:

> [root@am2mm v4l-dvb]# hg diff
> diff -r 6a189bc8f115 linux/drivers/media/video/em28xx/em28xx-audio.c
> --- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Dec 31
> 15:26:57 2008 -0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Dec 31
> 19:22:38 2008 -0500
> @@ -63,9 +63,12 @@
> 
>         dprintk("Stopping isoc\n");
>         for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> +               usb_kill_urb(dev->adev.urb[i]);
>                 usb_unlink_urb(dev->adev.urb[i]);

In this case, em28xx uses usb_unlink_urb() instead of usb_kill_urb().
This function does not wait for the urb to be fully stopped before
return to the caller (needed to avoid an already fixed oops).

>                 usb_free_urb(dev->adev.urb[i]);
>                 dev->adev.urb[i] = NULL;
> +               kfree(dev->adev.transfer_buffer[i]);
> +               dev->adev.transfer_buffer[i] = NULL;
>         }
> 

Seems ok, please send a new patch with your SOB (Signed-off-by).

Additional info:
http://www.linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

Thanks,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
