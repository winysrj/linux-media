Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:43223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab0L0PlB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 10:41:01 -0500
Message-ID: <4D18B389.7000007@redhat.com>
Date: Mon, 27 Dec 2010 13:40:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] Documentation/ioctl/ioctl-number.txt: Remove some
 now freed ioctl ranges
References: <cover.1293449547.git.mchehab@redhat.com> <201012271423.26288.hverkuil@xs4all.nl> <4D189C5D.9090203@redhat.com> <201012271608.32402.hverkuil@xs4all.nl>
In-Reply-To: <201012271608.32402.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 27-12-2010 13:08, Hans Verkuil escreveu:
> On Monday, December 27, 2010 15:02:05 Mauro Carvalho Chehab wrote:
>> Em 27-12-2010 11:23, Hans Verkuil escreveu:
>>> On Monday, December 27, 2010 14:03:03 Mauro Carvalho Chehab wrote:
>>>> Em 27-12-2010 10:01, Hans Verkuil escreveu:
>>>>> On Monday, December 27, 2010 12:38:39 Mauro Carvalho Chehab wrote:
>>>>>> The V4L1 removal patches removed a few ioctls. Update it at the docspace.
>>>>>>
>>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>>>
>>>>>> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
>>>>>> index 63ffd78..49d7f00 100644
>>>>>> --- a/Documentation/ioctl/ioctl-number.txt
>>>>>> +++ b/Documentation/ioctl/ioctl-number.txt
>>>>>> @@ -260,14 +260,11 @@ Code  Seq#(hex)	Include File		Comments
>>>>>>  't'	80-8F	linux/isdn_ppp.h
>>>>>>  't'	90	linux/toshiba.h
>>>>>>  'u'	00-1F	linux/smb_fs.h		gone
>>>>>> -'v'	all	linux/videodev.h	conflict!
>>>>>>  'v'	00-1F	linux/ext2_fs.h		conflict!
>>>>>>  'v'	00-1F	linux/fs.h		conflict!
>>>>>>  'v'	00-0F	linux/sonypi.h		conflict!
>>>>>> -'v'	C0-CF	drivers/media/video/ov511.h	conflict!
>>>>>>  'v'	C0-DF	media/pwc-ioctl.h	conflict!
>>>>>>  'v'	C0-FF	linux/meye.h		conflict!
>>>>>> -'v'	C0-CF	drivers/media/video/zoran/zoran.h	conflict!
>>>>>>  'v'	D0-DF	drivers/media/video/cpia2/cpia2dev.h	conflict!
>>>>>>  'w'	all				CERN SCI driver
>>>>>>  'y'	00-1F				packet based user level communications
>>>>>>
>>>>>
>>>>> There is also a line for media/ovcamchip.h in this file that can be removed.
>>>>
>>>> Ok, I'll do that.
>>>>
>>>>> The media/rds.h line can also be removed (this is kernel internal only).
>>>>
>>>> There are two rds.h, related to V4L:
>>>> ./include/linux/rds.h
>>>
>>> Not related to V4L, this is something from Oracle. It is this header that is public,
>>> not the media/rds.h header.
>>
>> Ah, ok.
>>
>>>> ./include/media/rds.h
>>>>
>>>> One of them is at the public api:
>>>>
>>>> include/linux/Kbuild:header-y += rds.h
>>>>
>>>> Btw, that's weird:
>>>>
>>>> $ git grep RDS_CMD_OPEN
>>>> drivers/media/video/saa6588.c:    case RDS_CMD_OPEN:
>>>> include/media/rds.h:#define RDS_CMD_OPEN  _IOW('R',1,int)
>>>>
>>>> as saa6588 is a subdev.
>>>>
>>>> IMO, we should remove or rename the internal header first.
>>>
>>> media/rds.h should be renamed to media/saa6588.h. It is also included in
>>> drivers/media/radio/si470x/radio-si470x.h, but that's obsolete and can be
>>> removed.
>>
>> The rds file were the old RDS API, before we add it at V4L2. We should, instead,
>> convert saa6588 to use the new way, and remove the legacy stuff.
> 
> No, this was never the RDS API. It is the saa6588 kernel-internal API.
> There is nothing wrong with it, except for the fact that the name suggests
> that this is a generic RDS API, when in fact it is saa6588 specific.
> 
>>>>> Ditto for media/bt819.h.
>>>>
>>>> There are also some issues there related to videodev2 stuff.
>>>>
>>>> I prefer to apply the path as-is (just removing the ovcamchip.h) and,
>>>> on some later cleanup, check and fix the remaining stuff.
>>>
>>> I can make a patch fixing the rds.h header usage. It's all internal stuff
>>> and the weird naming is just historical and should be changed.
>>
>> It would be nice if you can do it.
> 
> Will do.
> 
>>
>>>>>
>>>>> All other patches in this series:
>>>>>
>>>>> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>>
>>>> Thanks!
>>>>>
>>>>> BTW, it is probably also a good idea to move the dabusb driver to staging and
>>>>> mark it for removal in 2.6.39.
>>>>
>>>> Not sure about that. I don't see any good reason to remove dabusb driver, as
>>>> nobody reported that it is broken.
>>>
>>> Nobody has the hardware :-)
>>
>> This is too strong :) Are you absolutely sure that there's absolutely nobody in
>> the World with that hardware? ;)
> 
> I did some digging and found out the following:
> 
> The hardware in question was only an engineering sample which was later licensed
> to Terratec for their 'Dr Box 1' product.
> 
> See:
> 
> http://www.baycom.de/wiki/index.php/Products::dabusbhw
> http://www.baycom.de/wiki/index.php/Products::dabusb
> 
> The authors of the driver seemed to have developed the driver a bit more. The
> latest source I've been able to find it here:
> 
> http://www.baycom.de/download/dabusb/beta/dabusb-linux-i386.tgz
> 
> The driver in the kernel only supports the engineering samples. The newer driver
> on baycom.de also supports the Terratec product (which is no longer sold either).
> 
>>> I know you have asked the authors about a possible removal of this driver a few
>>> months ago. Did you get any reply from them?
>>
>> Nope.
> 
> You should try again, but use their baycom email:
> 
> http://www.baycom.de/wiki/index.php/Contact
>  
>>> It seems to be a demonstration driver only and I've never seen anyone with the
>>> hardware.
>>
>> It seems so, but I can't see any technical reason for its removal. The BKL fix were
>> applied on it, as someone wrote a patch for it.
> 
> There are a few reasons why I would like to remove this driver:
> 
> 1) The driver is for an engineering sample only which was never sold as a commercial
>    product.
> 2) The DAB API is completely undocumented and was never reviewed. Should other DAB
>    drivers ever appear, then I'd rather start from scratch defining an API then
>    continue this dubious API.
> 
> Perhaps baycom themselves might even be interested in working with us to design
> something better.

Ok, I sent another email. If we don't have any answer until the first week of Jan, let's
move it to staging and schedule it to die on .39.

Cheers,
Mauro
