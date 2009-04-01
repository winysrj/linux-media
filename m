Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40460 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765037AbZDASyk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 14:54:40 -0400
Received: by fxm2 with SMTP id 2so178361fxm.37
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2009 11:54:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904011936.20542.tobias.lorenz@gmx.net>
References: <1238544064.6154.38.camel@tux.localhost>
	 <200904011936.20542.tobias.lorenz@gmx.net>
Date: Wed, 1 Apr 2009 22:54:37 +0400
Message-ID: <208cbae30904011154u6fc54d88qc530f3b2f6961f9b@mail.gmail.com>
Subject: Re: [patch review] radio-si470x: fix possible bug with freeing memory
	order
From: Alexey Klimov <klimov.linux@gmail.com>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(add Mauro on c/c)

On Wed, Apr 1, 2009 at 9:36 PM, Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
> Hi,

Hi :)

> hey thanks. I appreciate and approve the patch.
>
> Do I have to upload the patch and send Mauro a pull request or is this
> already done?
>
> Bye,
>
> Toby

Well, as i understand that's to you or Mauro to decide.


> On Wednesday 01 April 2009 02:01:04 Alexey Klimov wrote:
>
>> Hello, all
>
>>
>
>> There is probably bug when cleanup occurs in si470x_usb_driver_probe.
>
>> We do kmalloc for radio->buffer and when it's fail we
>
>> kfree(radio->buffer). The same with si470x_get_all_registers() and
>
>> si470x_get_scratch_page_versions(). When this functions failed we go to
>
>> err_all and try to free radio->buffer before allocation memory for this.
>
>>
>
>> --
>
>> Patch fixes cleanup procedure in si470x_usb_driver_probe. Add new label
>
>> err_video and change order of freeing memory.
>
>>
>
>> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
>> --
>
>> diff -r 5567e82c34a0 linux/drivers/media/radio/radio-si470x.c
>
>> --- a/linux/drivers/media/radio/radio-si470x.c Tue Mar 31 07:24:14 2009
>> -0300
>
>> +++ b/linux/drivers/media/radio/radio-si470x.c Wed Apr 01 03:48:31 2009
>> +0400
>
>> @@ -1687,7 +1687,7 @@
>
>> /* show some infos about the specific si470x device */
>
>> if (si470x_get_all_registers(radio) < 0) {
>
>> retval = -EIO;
>
>> - goto err_all;
>
>> + goto err_video;
>
>> }
>
>> printk(KERN_INFO DRIVER_NAME ": DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
>
>> radio->registers[DEVICEID], radio->registers[CHIPID]);
>
>> @@ -1695,7 +1695,7 @@
>
>> /* get software and hardware versions */
>
>> if (si470x_get_scratch_page_versions(radio) < 0) {
>
>> retval = -EIO;
>
>> - goto err_all;
>
>> + goto err_video;
>
>> }
>
>> printk(KERN_INFO DRIVER_NAME
>
>> ": software version %d, hardware version %d\n",
>
>> @@ -1728,7 +1728,7 @@
>
>> radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
>
>> if (!radio->buffer) {
>
>> retval = -EIO;
>
>> - goto err_all;
>
>> + goto err_video;
>
>> }
>
>>
>
>> /* rds buffer configuration */
>
>> @@ -1750,8 +1750,9 @@
>
>>
>
>> return 0;
>
>> err_all:
>
>> + kfree(radio->buffer);
>
>> +err_video:
>
>> video_device_release(radio->videodev);
>
>> - kfree(radio->buffer);
>
>> err_radio:
>
>> kfree(radio);
>
>> err_initial:
>
>>
>
>>
>
>>



-- 
Best regards, Klimov Alexey
