Return-path: <video4linux-list-bounces@redhat.com>
From: Andy Walls <awalls@radix.net>
To: Mark Jenks <mjenks1968@gmail.com>
In-Reply-To: <e5df86c90901020803w75d5aab1g8b73b9da4c6b178@mail.gmail.com>
References: <e5df86c90901020803w75d5aab1g8b73b9da4c6b178@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 08:51:21 -0500
Message-Id: <1230990681.3119.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: {PATCH] If using HVR-1250 and HVR-1800 in the same system it
	causes kernel oops.
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

On Fri, 2009-01-02 at 10:03 -0600, Mark Jenks wrote:
> Analog support for HVR-1250 is not completed, but exists for the HVR-1800.
> This causes a NULL error to show up in video_open and mpeg_open.
> 
> -Mark

A few things:

1.  Your subject line has a typo: {PATCH] instead of [PATCH].  This
might cause people with automatic mail rules to miss the message.

2.  You forgot your Signed-off-by.  Read this:

http://linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Developer.27s_Certificate_of_Origin_1.1

and then add a line to the e-mail like "Signed-off-by: Mark Jenks
<mjenks1968@gmail.com>"


3. You need to Cc: the driver maintainer.  I believe the patch will need
his "Acked-by:", even if he himself doesn't put it in the repository.

(one more below ...)

> --- a/linux/drivers/media/video/cx23885/cx23885-417.c   2009-01-01
> 14:27:15.000000000 -0600
> +++ b/linux/drivers/media/video/cx23885/cx23885-417.c   2009-01-01
> 14:27:39.000000000 -0600
> @@ -1593,7 +1593,8 @@
>         lock_kernel();
>         list_for_each(list, &cx23885_devlist) {
>                 h = list_entry(list, struct cx23885_dev, devlist);
> -               if (h->v4l_device->minor == minor) {
> +               if (h->v4l_device &&
> +                   h->v4l_device->minor == minor) {
>                         dev = h;
>                         break;
>                 }
> --- a/linux/drivers/media/video/cx23885/cx23885-video.c Fri Dec 26 08:07:39
> 2008 -0200
> +++ b/linux/drivers/media/video/cx23885/cx23885-video.c Sun Dec 28 16:34:04
> 2008 -0500
> @@ -786,7 +786,8 @@ static int video_open(struct inode *inod
>        lock_kernel();
>        list_for_each(list, &cx23885_devlist) {
>                h = list_entry(list, struct cx23885_dev, devlist);
> -               if (h->video_dev->minor == minor) {
> +               if (h->video_dev &&
> +                   h->video_dev->minor == minor) {

4.  Modifying my original suggestion, maybe the better change here is:

		h = list_entry(list, struct cx23885_dev, devlist);
+		if (h->video_dev == NULL)
+			continue;
		if (h->video_dev->minor == minor) {




>                        dev  = h;
>                        type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>                }
> --


But if you want to submit the patch as is, for my contribution:

	Signed-off-by: Andy Walls <awalls@radix.net>


Sorry to be pedantic, but the (fia-)SCO litigation in recent years is
one reason the "Signed-off-by", "Acked-by", etc. is so critical.


Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
