Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:33355 "EHLO
        cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751307AbdBSXsI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 18:48:08 -0500
Subject: Re: [PATCH 1/1] hdpvr: code cleanup
To: Jonathan Sims <jonathan.625266@earthlink.net>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, ryleyjangus@gmail.com
References: <20170214201832.7a418b5a@earthlink.net>
From: Keith Pyle <kpyle@austin.rr.com>
Message-ID: <571b3eb9-374f-55b6-a918-74cc9e452798@austin.rr.com>
Date: Sun, 19 Feb 2017 17:40:00 -0600
MIME-Version: 1.0
In-Reply-To: <20170214201832.7a418b5a@earthlink.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/17 19:18, Jonathan Sims wrote:
> This is a code cleanup after recent changes introduced by commit a503ff812430e104f591287b512aa4e3a83f20b1.
>
> Signed-off-by: Jonathan Sims <jonathan.625266@earthlink.net>
> ---
>
>  drivers/media/usb/hdpvr/hdpvr-video.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 7fb036d6a86e..b2ce5c0807fb 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -449,7 +449,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
>  
>  		if (buf->status != BUFSTAT_READY &&
>  		    dev->status != STATUS_DISCONNECTED) {
> -			int err;
> +
>  			/* return nonblocking */
>  			if (file->f_flags & O_NONBLOCK) {
>  				if (!ret)
> @@ -457,23 +457,19 @@ static ssize_t hdpvr_read(struct file *file, char
> __user *buffer, size_t count, goto err;
>  			}
>  
> -			err =
> wait_event_interruptible_timeout(dev->wait_data,
> +			ret =
> wait_event_interruptible_timeout(dev->wait_data, buf->status ==
> BUFSTAT_READY, msecs_to_jiffies(1000));
> -			if (err < 0) {
> -				ret = err;
> +			if (ret < 0)
>  				goto err;
> -			}
> -			if (!err) {
> +			if (!ret) {
>  				v4l2_dbg(MSG_INFO, hdpvr_debug,
> &dev->v4l2_dev, "timeout: restart streaming\n");
>  				hdpvr_stop_streaming(dev);
> -				msecs_to_jiffies(4000);
> -				err = hdpvr_start_streaming(dev);
> -				if (err) {
> -					ret = err;
> +				msleep(4000);
> +				ret = hdpvr_start_streaming(dev);
> +				if (ret)
>  					goto err;
> -				}
>  			}
>  		}
>  

One comment and one suggestion:

I believe that the overall solution proposed above is an appropriate
means of dealing with hardware/firmware issues in the HD-PVR that lead
to failed captures reported by many people.  It will be a definite
improvement over the current situation.  However, it is important to
note that some player applications may have minor problems with the
resulting mpeg stream.  Restarting HD-PVR streaming results in the
equivalent of concatenating two separate mpeg streams into one file. 
Each segment has its own mpeg frame timestamps starting at 0.  ffmpeg
based applications don't fully handle such files.  For example, both
mplayer and vlc will play these streams correctly, but both have issues
attempting to skip within the stream (vlc skips little or not at all,
mplayer will skip but in smaller increments than normal).  ffprobe of
such a file will report the mpeg length as that of the last capture
segment rather than the total length of the file.  Still, having a
nearly complete capture (absent a few seconds during the restart) with
skip problems is far better than having a capture that stops well short
of the intended length.

Suggestion: Rather than just having a v4l2 debug message that streaming
was restarted, I think it would be desirable to have a timestamped
printk message showing the restart and the name of the HD-PVR device
(should the system have more than one).  This would allow users to more
readily tell that they have had this condition occur and how frequently.

Keith
