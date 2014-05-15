Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:11935 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751882AbaEODRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 23:17:05 -0400
Message-ID: <537431AF.6010900@austin.rr.com>
Date: Wed, 14 May 2014 22:17:03 -0500
From: Keith Pyle <kpyle@austin.rr.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ryley Angus <ryleyjangus@gmail.com>
Subject: Re: [PATCH] hdpvr: fix interrupted recording
References: <53742F4A.1090803@austin.rr.com>
In-Reply-To: <53742F4A.1090803@austin.rr.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/12/14 07:41, Hans Verkuil wrote:
> Ryley, Keith, can you test this one more time and if it works reply with
> a 'Tested-by' tag that I can add to the patch?
>
> Thanks!
>
> 	Hans
>
>
> This issue was reported by Ryley Angus:
>
> <quote>
> I record from my satellite set top box using component video and optical
> audio input. I basically use "cat /dev/video0 > ~/video.ts” or use dd. The
> box is set to output audio as AC-3 over optical, but most channels are
> actually output as stereo PCM. When the channel is changed between a PCM
> channel and (typically to a movie channel) to a channel utilising AC-3,
> the HD-PVR stops the recording as the set top box momentarily outputs no
> audio. Changing between PCM channels doesn't cause any issues.
>
> My main problem was that when this happens, cat/dd doesn't actually exit.
> When going through the hdpvr driver source and the dmesg output, I found
> the hdpvr driver wasn't actually shutting down the device properly until
> I manually killed cat/dd.
>
> I've seen references to this issue being a hardware issue from as far back
> as 2010:http://forums.gbpvr.com/showthread.php?46429-HD-PVR-drops-recording-on-channel-change-Hauppauge-says-too-bad  .
>
> I tracked my issue to the file hdpvr-video.c. Specifically:
> "if (wait_event_interruptible(dev->wait_data, buf->status = BUFSTAT_READY)) {"
> (line ~450). The device seems to get stuck waiting for the buffer to become
> ready. But as far as I can tell, when the channel is changed between a PCM
> and AC-3 broadcast the buffer status will never actually become ready.
> </quote>
>
> Angus provided a hack to fix this, which I've rewritten.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> Reported-by: Ryley Angus<ryleyjangus@gmail.com>
> ---
>   drivers/media/usb/hdpvr/hdpvr-video.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 0500c417..44227da 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -454,6 +454,8 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
>   
>   		if (buf->status != BUFSTAT_READY &&
>   		    dev->status != STATUS_DISCONNECTED) {
> +			int err;
> +
>   			/* return nonblocking */
>   			if (file->f_flags & O_NONBLOCK) {
>   				if (!ret)
> @@ -461,11 +463,23 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
>   				goto err;
>   			}
>   
> -			if (wait_event_interruptible(dev->wait_data,
> -					      buf->status == BUFSTAT_READY)) {
> -				ret = -ERESTARTSYS;
> +			err = wait_event_interruptible_timeout(dev->wait_data,
> +					      buf->status == BUFSTAT_READY,
> +					      msecs_to_jiffies(3000));
> +			if (err < 0) {
> +				ret = err;
>   				goto err;
>   			}
> +			if (!err) {
> +				v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
> +					"timeout: restart streaming\n");
> +				hdpvr_stop_streaming(dev);
> +				err = hdpvr_start_streaming(dev);
> +				if (err) {
> +					ret = err;
> +					goto err;
> +				}
> +			}
>   		}
>   
>   		if (buf->status != BUFSTAT_READY)
Unfortunately, 2 of my 3 tests failed.  The new code correctly detected 
the loss of signal and generated the timeout message for all three 
tests.  For tests 1 & 3, the HD-PVR did not restart streaming.  Test 1 
gave a 'Resource temporarily unavailable' error.  Test 3 did not produce 
an error message.

I believe I understand the problem.  In my user-space code that (mostly) 
deals with this problem, my algorithm differs slightly from that in 
Hans' code.  The proposed patch has this flow:

 1. watch for time-out on read for 3 seconds
 2. if no data is received in time-out period, close streaming on HD-PVR
 3. immediately re-open streaming from the HD-PVR


In my testing last year, I found that the HD-PVR is sensitive to being 
re-opened too soon.  The HD-PVR firmware seems to take a few seconds to 
reset itself after a close and be ready to accept a new open.  So, my 
flow is:

 1. watch for time-out on read for 1 second
 2. if no data received in timeout period, close the HD-PVR device
 3. sleep for 4 seconds
 4. re-open the HD-PVR device


I believe that Hans' patch fails my tests because there is no delay 
between the stop and start streaming calls in his patch. The minimum 
reliable time between such actions on my HD-PVR is 3 seconds.   I 
established this value by running a number of tests where I opened, 
closed, and re-open the device with different sleep times before the 
re-open.  I use 4 seconds to allow some additional safety.

I suggest the following two changes to Hans' patch:

 1. reduce the current read time-out from 3000 to 1000 ms. as 1 second
    has been highly reliable for detecting a data stall in my user-space
    code
 2. add a sleep of 4 seconds after the hdpvr_stop_streaming call to
    allow the HD-PVR to fully reset

Let me know if you have any questions.

Keith



