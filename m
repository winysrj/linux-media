Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63078 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756605AbaDHObR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Apr 2014 10:31:17 -0400
Message-ID: <5344077D.4030809@austin.rr.com>
Date: Tue, 08 Apr 2014 09:28:13 -0500
From: Keith Pyle <kpyle@austin.rr.com>
MIME-Version: 1.0
To: Ryley Angus <ryleyjangus@gmail.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] Fix interrupted recording with Hauppauge HD-PVR
References: <C2340839-C85B-4DDF-8590-FA9049D6E65E@gmail.com> <5342B115.2070909@xs4all.nl> <007a01cf52db$253a7fe0$6faf7fa0$@gmail.com>
In-Reply-To: <007a01cf52db$253a7fe0$6faf7fa0$@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/14 22:32, Ryley Angus wrote:
> Thanks Hans for getting back to me.
>
> I've been trying out your patch and I found the device wasn't actually
> restarting the streaming/recording properly after a channel
> change. I changed "msecs_to_jiffies(500))" to "msecs_to_jiffies(1000))" and
> had the same issue, but "msecs_to_jiffies(2000))"
> seems to be working well. I'll let it keep going for a few more hours, but
> at the moment it seems to be working well. The recordings
> can be ended without anything hanging, and turning off the device ends the
> recording properly (mine neglected this occurrence).
>
> I'll let you know if I have any more issues,
>
> ryley
>
> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, April 08, 2014 12:07 AM
> To: Ryley Angus; linux-media@vger.kernel.org
> Subject: Re: [RFC] Fix interrupted recording with Hauppauge HD-PVR
>
> Hi Ryley,
>
> Thank you for the patch. Your analysis seems sound. The patch is actually
> not bad for a first attempt, but I did it a bit differently.
>
> Can you test my patch?
>
> Regards,
>
> 	Hans
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c
> b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 0500c417..a61373e 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -454,6 +454,8 @@ static ssize_t hdpvr_read(struct file *file, char __user
> *buffer, size_t count,
>   
>   		if (buf->status != BUFSTAT_READY &&
>   		    dev->status != STATUS_DISCONNECTED) {
> +			int err;
> +
>   			/* return nonblocking */
>   			if (file->f_flags & O_NONBLOCK) {
>   				if (!ret)
> @@ -461,11 +463,23 @@ static ssize_t hdpvr_read(struct file *file, char
> __user *buffer, size_t count,
>   				goto err;
>   			}
>   
> -			if (wait_event_interruptible(dev->wait_data,
> -					      buf->status == BUFSTAT_READY))
> {
> -				ret = -ERESTARTSYS;
> +			err =
> wait_event_interruptible_timeout(dev->wait_data,
> +					      buf->status == BUFSTAT_READY,
> +					      msecs_to_jiffies(500));
> +			if (err < 0) {
> +				ret = err;
>   				goto err;
>   			}
> +			if (!err) {
> +				v4l2_dbg(MSG_INFO, hdpvr_debug,
> &dev->v4l2_dev,
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
>
>
> On 04/07/2014 02:04 AM, Ryley Angus wrote:
>> (Sorry in advance for probably breaking a few conventions of the
>> mailing lists. First time using one so please let me know what I'm
>> doing wrong)
>>
>> I'm writing this because of an issue I had with my Hauppauge HD-PVR.
>> I record from my satellite set top box using component video and
>> optical audio input. I basically use "cat /dev/video0 > ~/video.ts"
>> or use dd. The box is set to output audio as AC-3 over optical, but
>> most channels are actually output as stereo PCM. When the channel is
>> changed between a PCM channel and (typically to a movie channel) to a
>> channel utilising AC-3, the HD-PVR stops the recording as the set top
>> box momentarily outputs no audio. Changing between PCM channels
>> doesn't cause any issues.
>>
>> My main problem was that when this happens, cat/dd doesn't actually
>> exit. When going through the hdpvr driver source and the dmesg output,
>> I found the hdpvr driver wasn't actually shutting down the device
>> properly until I manually killed cat/dd.
>>
>> I've seen references to this issue being a hardware issue from as far
>> back as 2010:
>> http://forums.gbpvr.com/showthread.php?46429-HD-PVR-drops-recording-on
>> -channel-change-Hauppauge-says-too-bad
>> .
>>
>> I tracked my issue to the file "hdpvr-video.c". Specifically, "if
>> (wait_event_interruptible(dev->wait_data, buf->status =
>> BUFSTAT_READY)) {" (line ~450). The device seems to get stuck waiting
>> for the buffer to become ready. But as far as I can tell, when the
>> channel is changed between a PCM and AC-3 broadcast the buffer status
>> will never actually become ready.
>>
>> ...
I've seen the same problem Ryley describes and handled it in user space 
with a cat-like program that could detect stalls and re-open the hdpvr 
device.  This approach seems much better.  Kudos to both Ryley and Hans.

I concur that the 500 ms. timeout is too small.  When testing my 
program, I tried using a variety of timeout values when I found that the 
HD-PVR seems to require some delay following a close before it is ready 
to respond.  In my tests, anything of 2.5 seconds or less was not 
reliable.  I only reached 100% re-open reliability with a 3 second 
timeout.  It may be that 2 seconds will work with the code Hans posted, 
but you may want to do some additional testing.  It is also possible 
that my HD-PVR is more sensitive to the timeout (i.e., slower to become 
ready).

There is one other potential problem you may want to check.  With my 
user-space restart, the mpeg stream consists of two (or more) 
concatenated streams.  This causes some programs like vlc to have 
problems (e.g., doing forward jumps) since it only sees the length of 
the last of the streams.  I'm not clear if this can also occur with your 
patch.

Keith


