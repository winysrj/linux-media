Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab0H1P0D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Aug 2010 11:26:03 -0400
Message-ID: <4C792BE1.6090001@redhat.com>
Date: Sat, 28 Aug 2010 17:31:45 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jonathan Isom <jeisom@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patryk Biela <patryk.biela@gmail.com>
Subject: Re: ibmcam (xrilink_cit) and konica webcam driver porting to gspca
 update
References: <4C3070A4.6040702@redhat.com> <AANLkTinXb=TeSGO_6Mr6jhzaUOUZ3yZL5+oAP2GP0GG5@mail.gmail.com>
In-Reply-To: <AANLkTinXb=TeSGO_6Mr6jhzaUOUZ3yZL5+oAP2GP0GG5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On 08/28/2010 12:54 AM, Jonathan Isom wrote:
> On Sun, Jul 4, 2010 at 6:29 AM, Hans de Goede<hdegoede@redhat.com>  wrote:
>> Hi all,
>>
>> I've finished porting the usbvideo v4l1 ibmcam and
>> konicawc drivers to gspcav2.
>>
>> The ibmcam driver is replaced by gspca_xirlink_cit, which also
>> adds support for 2 new models (it turned out my testing cams
>> where not supported by the old driver). This one could use
>> more testing.
>
> I just tried using your driver. I get no video.  using 2.6.35.3.  Had
> to patch usb_buffer_[alloc&  free]
> otherwise no changes to your tree.
>
>> /usr/bin/qv4l2 /dev/video2
> Start Capture: Input/output error
> VIDIOC_STREAMON: Input/output error
> Start Capture: Input/output error
> VIDIOC_STREAMON: Input/output error
>

Thanks for testing!

Ok, so a couple of things:
1) For the new xirlink cit driver to work you need the latest libv4l
from v4l-utils (use the just released 0.8.1 for example), but that
does not explain the io errors.

2) Make sure you the old usbvideo ibmcam driver is no used (remove the
.ko file from /lib/modules/...

3) Do
echo 63 > /sys/module/gspca_main/parameters/debug
(as root, note sudo does not work with redirects)

And then try some application again and after trying do
dmesg > dmesg.txt and attach dmesg.txt to your next reply.

4) What did you need to change exactly, can you share the changes
in question with me in the form of a patch ? (I'm waiting for
Douglas to sync the main hg v4l-dvb tree with the latest upstream /
mauro's tree and then I'll rebase my ibmcam tree.

5) Do
lsusb -v > lsusb.log and attach that to your next mail too.

Thanks & Regards,

Hans


> -- info
> Model 2	
> KSX-X9903	
> 0x0545
> 0x8080
> 3.0a
> Old, cheaper model	Xirlink C-It
>
> /usr/sbin/v4l2-dbg -d /dev/video2 -D
> Driver info:
>          Driver name   : xirlink-cit
>          Card type     : USB IMAGING DEVICE
>          Bus info      : usb-0000:00:12.2-6.1
>          Driver version: 133376
>          Capabilities  : 0x05000001
>                  Video Capture
>                  Read/Write
>                  Streaming
>
> Any Ideas
>
> Jonathan
>
>
>
>
>
>> The konicawc driver is replaced by gspca_konica which is
>> pretty much finished.
>>
>> You can get them both here:
>> http://linuxtv.org/hg/~hgoede/ibmcam
>>
>> Once Douglas updates the hg v4l-dvb tree to be up2date with
>> the latest and greatest from Mauro, then I'll rebase my
>> tree (the ibmcam driver needs a very recent gspca core patch),
>> and send a pull request.
>>
>> Regards,
>>
>> Hans
>>
>>
>> p.s.
>>
>> 1) Many thanks to Patryk Biela for providing me a konica
>>    driver using camera.
>> 2) Still to do the se401 driver.
>> 3) I'll be on vacation the coming week and not reading email.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
