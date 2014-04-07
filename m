Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3619 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbaDGOHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 10:07:38 -0400
Message-ID: <5342B115.2070909@xs4all.nl>
Date: Mon, 07 Apr 2014 16:07:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ryley Angus <ryleyjangus@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [RFC] Fix interrupted recording with Hauppauge HD-PVR
References: <C2340839-C85B-4DDF-8590-FA9049D6E65E@gmail.com>
In-Reply-To: <C2340839-C85B-4DDF-8590-FA9049D6E65E@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ryley,

Thank you for the patch. Your analysis seems sound. The patch is
actually not bad for a first attempt, but I did it a bit differently.

Can you test my patch?

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 0500c417..a61373e 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -454,6 +454,8 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 
 		if (buf->status != BUFSTAT_READY &&
 		    dev->status != STATUS_DISCONNECTED) {
+			int err;
+
 			/* return nonblocking */
 			if (file->f_flags & O_NONBLOCK) {
 				if (!ret)
@@ -461,11 +463,23 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 				goto err;
 			}
 
-			if (wait_event_interruptible(dev->wait_data,
-					      buf->status == BUFSTAT_READY)) {
-				ret = -ERESTARTSYS;
+			err = wait_event_interruptible_timeout(dev->wait_data,
+					      buf->status == BUFSTAT_READY,
+					      msecs_to_jiffies(500));
+			if (err < 0) {
+				ret = err;
 				goto err;
 			}
+			if (!err) {
+				v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
+					"timeout: restart streaming\n");
+				hdpvr_stop_streaming(dev);
+				err = hdpvr_start_streaming(dev);
+				if (err) {
+					ret = err;
+					goto err;
+				}
+			}
 		}
 
 		if (buf->status != BUFSTAT_READY)


On 04/07/2014 02:04 AM, Ryley Angus wrote:
> (Sorry in advance for probably breaking a few conventions of the
> mailing lists. First time using one so please let me know what I’m
> doing wrong)
> 
> I’m writing this because of an issue I had with my Hauppauge HD-PVR.
> I record from my satellite set top box using component video and
> optical audio input. I basically use "cat /dev/video0 > ~/video.ts”
> or use dd. The box is set to output audio as AC-3 over optical, but
> most channels are actually output as stereo PCM. When the channel is
> changed between a PCM channel and (typically to a movie channel) to a
> channel utilising AC-3, the HD-PVR stops the recording as the set top
> box momentarily outputs no audio. Changing between PCM channels
> doesn’t cause any issues.
> 
> My main problem was that when this happens, cat/dd doesn’t actually
> exit. When going through the hdpvr driver source and the dmesg
> output, I found the hdpvr driver wasn’t actually shutting down the
> device properly until I manually killed cat/dd.
> 
> I’ve seen references to this issue being a hardware issue from as far
> back as 2010:
> http://forums.gbpvr.com/showthread.php?46429-HD-PVR-drops-recording-on-channel-change-Hauppauge-says-too-bad
> .
> 
> I tracked my issue to the file “hdpvr-video.c”. Specifically, “if
> (wait_event_interruptible(dev->wait_data, buf->status =
> BUFSTAT_READY)) {“ (line ~450). The device seems to get stuck waiting
> for the buffer to become ready. But as far as I can tell, when the
> channel is changed between a PCM and AC-3 broadcast the buffer status
> will never actually become ready.
> 
> I haven’t really ever done much coding, but I wrote a really nasty
> patch for this which tracks the devices buffer status and
> stops/starts the devices recording when the buffer is not ready for a
> period of time. In my limited testing it has worked perfectly, no
> output is overwritten, the output is in sync and the recording
> changes perfectly between stereo AC-3 (PCM input is encoded to AC-3
> by the hardware) and 5.1 AC-3 no matter how frequently I change the
> channels back and forth. All changes are transparent to cat/dd and
> neither exit prematurely. Manually killing cat/dd seems to properly
> shut down the device. There is a half-second glitch in the resultant
> where the recording restarts, but this amounts to less than a second
> of lost footage during the change and compared to having the device
> hang, I can live with it. I haven’t had the device restart recording
> when it shouldn’t have.
> 
> So considering my code is really messy, I’d love it if someone could
> make some suggestions to make the code better and make sure I don’t
> have too many logic errors. I don’t really know too much about kernel
> coding practices either. And if anyone who’s experienced my issue
> could try out my change and let me know that’d be great. You will
> have to run "v4l2-ctl --verbose -d /dev/video0 -c audio_encoding=4”
> to ensure the 5.1 AC-3 is captured properly (AAC capture of 5.1
> sources doesn’t seem possible) and "v4l2-ctl --verbose -d $MPEG4_IN
> --set-audio-input=2” to capture from the optical input.
> Thanks in advance,
> 
> ryley
> 
> 
> --- a/hdpvr-video.c	2014-04-07 09:34:31.000000000 +1000
> +++ b/hdpvr-video.c	2014-04-07 09:37:44.000000000 +1000
> @@ -453,11 +453,17 @@
>  					ret = -EAGAIN;
>  				goto err;
>  			}
> -
> -			if (wait_event_interruptible(dev->wait_data,
> -					      buf->status == BUFSTAT_READY)) {
> -				ret = -ERESTARTSYS;
> -				goto err;
> +			int counter=0;
> +			while (buf->status != BUFSTAT_READY) {
> +				counter++;
> +				msleep(20);
> +				if (counter == 30) {
> +					v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
> +                                                "limit hit, counter is %d, buf status is %d\n", counter, buf->status);
> +					counter=0;
> +					ret = hdpvr_stop_streaming(dev);
> +					ret = hdpvr_start_streaming(dev);
> +				}
>  			}
>  		}
> 
> 
> 
> 
> 
> 

