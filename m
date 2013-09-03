Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:39702
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759831Ab3ICLbo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Sep 2013 07:31:44 -0400
Message-ID: <5225C87D.2010606@licor.com>
Date: Tue, 3 Sep 2013 06:31:09 -0500
From: Darryl <ddegraff@licor.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: davinci vpif_capture
References: <5220CADF.5050805@licor.com> <CA+V-a8t7sb9HVACCVTDG0c2LH6Ca=Tc7EY=UmU38apKNjVdZyA@mail.gmail.com>
In-Reply-To: <CA+V-a8t7sb9HVACCVTDG0c2LH6Ca=Tc7EY=UmU38apKNjVdZyA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2013 06:15 AM, Prabhakar Lad wrote:
> On Fri, Aug 30, 2013 at 10:09 PM, Darryl <ddegraff@licor.com> wrote:
>> I am working on an application involving the davinci using the vpif.  My
>> board file has the inputs configured to use VPIF_IF_RAW_BAYER if_type.
>> When my application starts up, I have it enumerate the formats
>> (VIDIOC_ENUM_FMT) and it indicates that the only available format is
>> "YCbCr4:2:2 YC Planar" (from vpif_enum_fmt_vid_cap).  It looks to me that
>> the culprit is vpif_open().
>>
>> struct channel_obj.vpifparams.iface is initialized at vpif_probe() time in
>> the function vpif_set_input.  Open the device file (/dev/video0) overwrites
>> this.  I suspect that it is __not__ supposed to do this, since I don't see
>> any method for restoring the iface.
>>
> NAK, Ideally the application should go in the following manner,
> you open the device say example /dev/video0 , then you issue
> a VIDIOC_ENUMINPUT IOCTL,  this will enumerate the inputs
> then you do  VIDIOC_S_INPUT this will select the input device
> so when this IOCTL is called vpif_s_input() is called in vpif_capture
> driver this function will internally call the vpif_set_input() which
> will set the iface for you on line 1327.

Is there a document or documents where I can find this "following 
manner"?  I've read through a lot of v4l docs, but none seem to suggest 
an ordered sequence of ioctl calls.

>
> In the probe it calls vpif_set_input() to select input 0 as a default device.
>
> Hope this clears your doubt.
>
> Regards,
> --Prabhakar Lad
>
>> I'm using linux-3.10.4, but the problem appears in 3.10.9, 3.11.rc7 and a
>> version I checked out at
>> https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git. I
>> have supplied a patch for 3.10.9.
>>
>>
>> diff -pubwr
>> linux-3.10.9-pristine/drivers/media/platform/davinci/vpif_capture.c
>> linux-3.10.9/drivers/media/platform/davinci/vpif_capture.c
>> --- linux-3.10.9-pristine/drivers/media/platform/davinci/vpif_capture.c
>> 2013-08-20 17:40:47.000000000 -0500
>> +++ linux-3.10.9/drivers/media/platform/davinci/vpif_capture.c  2013-08-30
>> 11:18:29.000000000 -0500
>> @@ -914,9 +914,11 @@ static int vpif_open(struct file *filep)
>>       fh->initialized = 0;
>>       /* If decoder is not initialized. initialize it */
>>       if (!ch->initialized) {
>> +        struct vpif_interface iface = ch->vpifparams.iface;
>>           fh->initialized = 1;
>>           ch->initialized = 1;
>>           memset(&(ch->vpifparams), 0, sizeof(struct vpif_params));
>> +        ch->vpifparams.iface = iface;
>>       }
>>       /* Increment channel usrs counter */
>>       ch->usrs++;
>>
>>
>>
>>
>> _______________________________________________
>> Davinci-linux-open-source mailing list
>> Davinci-linux-open-source@linux.davincidsp.com
>> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source


