Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2355 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3KJLpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 06:45:22 -0500
Message-ID: <527F71CA.9040205@xs4all.nl>
Date: Sun, 10 Nov 2013 12:45:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Lorenz_R=F6hrl?= <sheepshit@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: BUG: Freeze upon loading bttv module
References: <527E606A.40101@gmx.de> <527EBEA4.1070202@xs4all.nl> <527F4551.6090708@gmx.de>
In-Reply-To: <527F4551.6090708@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lorenz,

On 11/10/2013 09:35 AM, Lorenz R�hrl wrote:
> Hi Hans,
> 
> 
> On 11/10/2013 12:00 AM, Hans Verkuil wrote:
>>
>> Can you try this patch? I'm not 100% but I think this might be the cause of
>> the problem.
>>
>> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
>> index c6532de..4f0aaa5 100644
>> --- a/drivers/media/pci/bt8xx/bttv-driver.c
>> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
>> @@ -4182,7 +4182,8 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
>>   	}
>>   	btv->std = V4L2_STD_PAL;
>>   	init_irqreg(btv);
>> -	v4l2_ctrl_handler_setup(hdl);
>> +	if (!bttv_tvcards[btv->c.type].no_video)
>> +		v4l2_ctrl_handler_setup(hdl);
>>   	if (hdl->error) {
>>   		result = hdl->error;
>>   		goto fail2;
>>
>>
> 
> I tried the patch and indeed it's working :)
> No freeze on loading the module and the dvb-device is also working.

Thanks for testing this! Good news that it fixed the problem.

> 
> lolo@hurra ~ % ls /dev/dvb/adapter0
> demux0  dvr0  frontend0
> 
> lolo@hurra ~ % dmesg |grep bttv
> [    0.871060] bttv: driver version 0.9.19 loaded
> [    0.872005] bttv: using 8 buffers with 2080k (520 pages) each for capture
> [    0.873137] bttv: Bt8xx card found (0)
> [    0.874186] bttv: 0: Bt878 (rev 17) at 0000:04:01.0, irq: 16, 
> latency: 32, mmio: 0xf0401000
> [    0.875156] bttv: 0: detected: Twinhan VisionPlus DVB [card=113], PCI 
> subsystem ID is 1822:0001
> [    0.876138] bttv: 0: using: Twinhan DST + clones [card=113,autodetected]
> [    0.884082] bttv: 0: tuner absent
> [    0.894011] bttv: 0: add subdevice "dvb0"
> [    0.901398] DVB: registering new adapter (bttv0)
> 
> 
> Will this patch be included upstream? When will it appear in official 
> kernel sources?

I'll make a pull request for this tomorrow for 3.13 with a CC to the stable kernel
mailinglist. It will probably take a few weeks before it appears in the mainline
kernel and in the older, stable, kernels. I would expect this to be fixed by the
end of the year.

Regards,

	Hans
