Return-path: <linux-media-owner@vger.kernel.org>
Received: from vpndallas.adeneo-embedded.us ([162.254.209.190]:32044 "EHLO
	mxadeneo.adeneo-embedded.us" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750722AbcBARrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2016 12:47:18 -0500
Date: Mon, 1 Feb 2016 09:47:13 -0800
From: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
Subject: Re: [PATCH v2] [media] cx231xx: fix close sequence for VBI + analog
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>
Message-ID: <1454348833.16224.1@mxadeneo.adeneo-embedded.us>
In-Reply-To: <20160201133325.069f22ad@recife.lan>
References: <1454092619-27700-1-git-send-email-jtheou@adeneo-embedded.us>
	<1454094304-4520-1-git-send-email-jtheou@adeneo-embedded.us>
	<20160201133325.069f22ad@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for your feedback.


On Mon, Feb 1, 2016 at 7:33 AM, Mauro Carvalho Chehab 
<mchehab@osg.samsung.com> wrote:
> Em Fri, 29 Jan 2016 11:05:04 -0800
> Jean-Baptiste Theou <jtheou@adeneo-embedded.us> escreveu:
> 
>>  For tuners with no_alt_vanc=0, and VBI and analog video device
>>  open.
>>  There is two ways to close the devices:
>> 
>>  *First way (start with user=2)
>> 
>>  VBI first (user=1): URBs for the VBI are killed properly
>>  with cx231xx_uninit_vbi_isoc
>> 
>>  Analog second (user=0): URBs for the Analog are killed
>>  properly with cx231xx_uninit_isoc
>> 
>>  *Second way (start with user=2)
>> 
>>  Analog first (user=1): URBs for the Analog are NOT killed
>>  properly with cx231xx_uninit_isoc, because the exit path
>>  is not called this time.
>> 
>>  VBI first (user=0): URBs for the VBI are killed properly with
>>  cx231xx_uninit_vbi_isoc, but we are exiting the function
>>  without killing the URBs for the Analog
>> 
>>  This situation lead to various kernel panics, since
>>  the URBs are still processed, without the device been
>>  open.
>> 
>>  The patch fix the issue by calling the exit path no matter
>>  what, when user=0, plus remove a duplicate trace.
>> 
>>  Signed-off-by: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
>> 
>>  ---
>> 
>>   - v2: Avoid duplicate code and ensure that the queue are freed
>>         properly.
>>  ---
>>   drivers/media/usb/cx231xx/cx231xx-video.c | 44 
>> +++++++++----------------------
>>   1 file changed, 12 insertions(+), 32 deletions(-)
>> 
>>  diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c 
>> b/drivers/media/usb/cx231xx/cx231xx-video.c
>>  index 9b88cd8..a832c83 100644
>>  --- a/drivers/media/usb/cx231xx/cx231xx-video.c
>>  +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
>>  @@ -1836,10 +1836,21 @@ static int cx231xx_close(struct file *filp)
>> 
>>   	cx231xx_videodbg("users=%d\n", dev->users);
>> 
>>  -	cx231xx_videodbg("users=%d\n", dev->users);
>>   	if (res_check(fh))
>>   		res_free(fh);
>> 
>>  +	videobuf_stop(&fh->vb_vidq);
>>  +	videobuf_mmap_free(&fh->vb_vidq);
>>  +
>>  +	/* the device is already disconnect,
>>  +	 * free the remaining resources
>>  +	 */
>>  +	if (dev->state & DEV_DISCONNECTED) {
>>  +		cx231xx_release_resources(dev);
>>  +		fh->dev = NULL;
>>  +		return 0;
>>  +	}
>>  +
>>   	/*
>>   	 * To workaround error number=-71 on EP0 for VideoGrabber,
>>   	 *	 need exclude following.
> 
> Hmm... The above doesn't sound right to stop the queue 
> unconditionally when
> users != 0, as one could do weird things like:
> 
> start video
> start vbi
> stop vbi
> start vbi
> stop video
> stop vbi
> 
> Those weird workflows happen when someone is using a TV application
> like TVtime for capturing images, while using a different app, like
> zvbi to get VBI data.
> 
> So, I guess that the above hunked should be removed...
> 
> 
>>  @@ -1848,19 +1859,6 @@ static int cx231xx_close(struct file *filp)
>>   	 */
>>   	if (!dev->board.no_alt_vanc)
>>   		if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
>>  -			videobuf_stop(&fh->vb_vidq);
>>  -			videobuf_mmap_free(&fh->vb_vidq);
>>  -
>>  -			/* the device is already disconnect,
>>  -			   free the remaining resources */
>>  -			if (dev->state & DEV_DISCONNECTED) {
>>  -				if (atomic_read(&dev->devlist_count) > 0) {
>>  -					cx231xx_release_resources(dev);
>>  -					fh->dev = NULL;
>>  -					return 0;
>>  -				}
>>  -				return 0;
>>  -			}
>> 
>>   			/* do this before setting alternate! */
>>   			cx231xx_uninit_vbi_isoc(dev);
>>  @@ -1870,29 +1868,11 @@ static int cx231xx_close(struct file *filp)
>>   				cx231xx_set_alt_setting(dev, INDEX_VANC, 0);
>>   			else
>>   				cx231xx_set_alt_setting(dev, INDEX_HANC, 0);
>>  -
>>  -			v4l2_fh_del(&fh->fh);
>>  -			v4l2_fh_exit(&fh->fh);
>>  -			kfree(fh);
>>  -			dev->users--;
>>  -			wake_up_interruptible(&dev->open);
>>  -			return 0;
>>   		}
>> 
> 
> The above changes are OK...
> 
>>   	v4l2_fh_del(&fh->fh);
>>   	dev->users--;
>>   	if (!dev->users) {
>>  -		videobuf_stop(&fh->vb_vidq);
>>  -		videobuf_mmap_free(&fh->vb_vidq);
>>  -
>>  -		/* the device is already disconnect,
>>  -		   free the remaining resources */
>>  -		if (dev->state & DEV_DISCONNECTED) {
>>  -			cx231xx_release_resources(dev);
>>  -			fh->dev = NULL;
>>  -			return 0;
>>  -		}
>>  -
> 
> But the above code should be kept, as we should only stop/free
> resources when neither VBI or Video is running. Other drivers do
> similar things and work properly. See em28xx for example (I'm sure
> em28xx video/vbi is working as expected, as I did such tests last
> week).

My understanding of this code is that the VBI and the VIDEO device have 
they own vb_vidq,
so if videobuf_stop and video_mmap_free are called only when user=0, 
one device
(the first one to be close) will not be freed properly.

This is why I am stopping the use of the buffers and release the memory 
first for every call
of close().

Am I missing the way this code works?

> 
> 
>>   		/* Save some power by putting tuner to sleep */
>>   		call_all(dev, core, s_power, 0);
>> 
> 
> Regards,
> Mauro

Best regards,

Jean-Baptiste

