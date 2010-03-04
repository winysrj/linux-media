Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f197.google.com ([209.85.211.197]:56787 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0CDF6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 00:58:38 -0500
Received: by ywh35 with SMTP id 35so789391ywh.4
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 21:58:37 -0800 (PST)
Message-ID: <4B8F7580.8040506@gmail.com>
Date: Thu, 04 Mar 2010 03:55:28 -0500
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: dougsland@redhat.com
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [hg:v4l-dvb] gspca - main: Fix a compile error when CONFIG_INPUT
 is not set
References: <E1Nmblu-0007t3-Dm@www.linuxtv.org> <20100303095123.047a4d1e@tele> <4B8E8BF9.7000307@redhat.com>
In-Reply-To: <4B8E8BF9.7000307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jean,

On 03/03/2010 11:19 AM, Douglas Schilling Landgraf wrote:
> Hi,
>
> Jean-Francois Moine wrote:
>> On Wed, 03 Mar 2010 00:45:02 +0100
>> Patch from Jean-Fran?ois Moine <hg-commit@linuxtv.org> wrote:
>>
>>> The patch number 14343 was added via Douglas Schilling Landgraf
>>> <dougsland@redhat.com> to http://linuxtv.org/hg/v4l-dvb master
>>> development tree.
>>>
>>> Kernel patches in this development tree may be modified to be backward
>>> compatible with older kernels. Compatibility modifications will be
>>> removed before inclusion into the mainstream Kernel
>>>
>>> If anyone has any objections, please let us know by sending a message
>>> to: Linux Media Mailing List <linux-media@vger.kernel.org>
>>>
>>> ------
>>>
>>> From: Jean-Fran?ois Moine <moinejf@free.fr>
>>> gspca - main: Fix a compile error when CONFIG_INPUT is not set
>>>
>>>
>>> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Priority: normal
>>>
>>> [dougsland@redhat.com: patch backported to hg tree]
>>> Signed-off-by: Jean-Fran?ois Moine <moinejf@free.fr>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
>>>
>>>
>>> ---
>>>
>>>  linux/drivers/media/video/gspca/gspca.c |    6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff -r c533329e3c41 -r 6519c63ecf6d
>>> linux/drivers/media/video/gspca/gspca.c ---
>>> a/linux/drivers/media/video/gspca/gspca.c    Tue Mar 02 20:16:17
>>> 2010 -0300 +++ b/linux/drivers/media/video/gspca/gspca.c    Tue
>>> Mar 02 20:38:01 2010 -0300 @@ -44,10 +44,12 @@  #include "gspca.h"
>>>
>>> +#ifdef CONFIG_INPUT
>>>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
>>>  #include <linux/input.h>
>>>  #include <linux/usb/input.h>
>>>  #endif
>>> +#endif
>>>
>>>  /* global values */
>>>  #define DEF_NURBS 3        /* default number of URBs */
>>> @@ -2371,9 +2373,11 @@
>>>  void gspca_disconnect(struct usb_interface *intf)
>>>  {
>>>      struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
>>> +#ifdef CONFIG_INPUT
>>>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
>>>      struct input_dev *input_dev;
>>>  #endif
>>> +#endif
>>>
>>>      PDEBUG(D_PROBE, "%s disconnect",
>>>          video_device_node_name(&gspca_dev->vdev));
>>> @@ -2385,6 +2389,7 @@
>>>          wake_up_interruptible(&gspca_dev->wq);
>>>      }
>>>
>>> +#ifdef CONFIG_INPUT
>>>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
>>>      gspca_input_destroy_urb(gspca_dev);
>>>      input_dev = gspca_dev->input_dev;
>>> @@ -2393,6 +2398,7 @@
>>>          input_unregister_device(input_dev);
>>>      }
>>>  #endif
>>> +#endif
>>>
>>>      /* the device is freed at exit of this function */
>>>      gspca_dev->dev = NULL;
>>>
>>>
>>> ---
>>>
>>> Patch is available at:
>>> http://linuxtv.org/hg/v4l-dvb/rev/6519c63ecf6d4e7e2c1c3d46ac2a161da8d6c6f4 
>>>
>>
>> Hello Douglas,
>>
>> I do not understand your patch. Do you mean that the input events
>> cannot be used with kernel < 2.6.19, while CONFIG_INPUT can be set?
> >
>> Anyway, this patch seems complex. It would have been easier to simply
>> unset CONFIG_INPUT when kernel < 2.6.19.
>
> Agreed. Anyway, there are parts which still need CONFIG_INPUT if we 
> want to remove the kernel check. Going to review this one.
>
>> I join the diff of gspca.c between v4l-dvb and my repository. This last
>> one is closer to the git version and there are still other changes done
>> in git. How do you think I should merge?
>
> If I understand your question correctly, the better way is wait until 
> I complete the merge between git and hg which I intend to complete 
> today and then merge the hg trees. I will give you a note.
>

git and hg are synced, now I will work about compatible items in the tree.

Cheers
Douglas
