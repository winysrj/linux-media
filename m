Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2E1OJS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 10:09:18 -0400
Message-ID: <4FC386FE.7040609@redhat.com>
Date: Mon, 28 May 2012 11:09:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] firedtv: Port it to use rc_core
References: <1338210875-4620-1-git-send-email-mchehab@redhat.com> <1338210875-4620-2-git-send-email-mchehab@redhat.com> <20120528160132.2041d761@stein>
In-Reply-To: <20120528160132.2041d761@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-05-2012 11:01, Stefan Richter escreveu:
> On May 28 Mauro Carvalho Chehab wrote:
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/dvb/firewire/firedtv-rc.c |  152 ++-----------------------------
>>  drivers/media/dvb/firewire/firedtv.h    |    2 +-
>>  2 files changed, 11 insertions(+), 143 deletions(-)
> 
> Also in drivers/media/dvb/firewire/Kconfig, INPUT needs to be replaced by
> RC_CORE, right?
> 
>> diff --git a/drivers/media/dvb/firewire/firedtv-rc.c b/drivers/media/dvb/firewire/firedtv-rc.c
>> index f82d4a9..3c2c9b3 100644
>> --- a/drivers/media/dvb/firewire/firedtv-rc.c
>> +++ b/drivers/media/dvb/firewire/firedtv-rc.c
> 
> -#include <linux/input.h>
> +#include <media/rc-core.h>

Ok.
> 
> [...]
>>  int fdtv_register_rc(struct firedtv *fdtv, struct device *dev)
>>  {
>> -	struct input_dev *idev;
>> +	struct rc_dev *idev;
>>  	int i, err;
>>  
>> -	idev = input_allocate_device();
>> +	idev = rc_allocate_device();
>>  	if (!idev)
>>  		return -ENOMEM;
>>  
>>  	fdtv->remote_ctrl_dev = idev;
>>  	idev->name = "FireDTV remote control";
>> +	idev->phys = "/ir0";		/* FIXME */
> 
> Something similar to drivers/media/dvb/dvb-usb/dvb-usb-remote.c::
> 
> 	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
> 	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
> 
> should be implemented for this, right?

Yes. I dunno how are the physical descriptions for firewire, but we
generally use the same way as it is there at sysfs. This is not an
absolute requirement for the RC core to work.
> 
> Also, idev->name should be idev->input_name and idev->phys should be
> idev->input_phys.

Yeah, you're right... Weird that I didn't notice any compilation issue here.

>> --- a/drivers/media/dvb/firewire/firedtv.h
>> +++ b/drivers/media/dvb/firewire/firedtv.h
> 
> -struct input_dev;
> +struct struct rc_dev;
> 
>> @@ -91,7 +91,7 @@ struct firedtv {
>>  	wait_queue_head_t	avc_wait;
>>  	bool			avc_reply_received;
>>  	struct work_struct	remote_ctrl_work;
>> -	struct input_dev	*remote_ctrl_dev;
>> +	struct rc_dev		*remote_ctrl_dev;
>>  
>>  	enum model_type		type;
>>  	char			subunit;
> 
> (Do you want to reroll it or should I resubmit it myself after actually
> trying it?)

Feel free to fix and resubmit it after testing.

Regards,
Mauro
