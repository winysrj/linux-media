Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:49627 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbdEBSl1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 May 2017 14:41:27 -0400
Date: Tue, 2 May 2017 20:41:23 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 15/16] lirc_dev: remove name from struct lirc_driver
Message-ID: <20170502184123.hbcxshssjjcow35s@hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
 <149365469232.12922.13451178429094271759.stgit@zeus.hardeman.nu>
 <20170502170417.GA27820@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170502170417.GA27820@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 02, 2017 at 06:04:18PM +0100, Sean Young wrote:
>On Mon, May 01, 2017 at 06:04:52PM +0200, David Härdeman wrote:
>> The name is only used for a few debug messages and the name of the parent
>> device as well as the name of the lirc device (e.g. "lirc0") are sufficient
>> anyway.
>>...
>> @@ -207,8 +204,7 @@ lirc_register_driver(struct lirc_driver *d)
>>  	if (err)
>>  		goto out_cdev;
>>  
>> -	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
>> -		 ir->d.name, ir->d.minor);
>> +	dev_info(ir->d.dev, "lirc device registered as lirc%d\n", minor);
>
>I'm not so sure this is a good idea. First of all, the documentation says
>you can use "dmesg |grep lirc_dev" to find your lirc devices and you've
>just replaced lirc_dev with lirc.

Sure, no strong preferences here, you could change the line to say
"lirc_dev device...", or drop the patch.

>https://linuxtv.org/downloads/v4l-dvb-apis/uapi/rc/lirc-dev-intro.html
>
>It's useful having the driver name in the message. For example, I have
>two rc devices connected usually:
>
>[sean@bigcore ~]$ dmesg | grep lirc_dev
>[    5.938284] lirc_dev: IR Remote Control driver registered, major 239
>[    5.945324] rc rc0: lirc_dev: driver ir-lirc-codec (winbond-cir) registered at minor = 0
>[ 5111.830118] rc rc1: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 1

winbond-cir....good man :)

How about "dmesg | grep lirc -A2 -B2"?

I don't think the situation is that different from how you'd know which
input dev is allocated to any given rc_dev? With this patch applied the
relevant output will be:

[    0.393494] rc rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    0.394458] input: rc-core loopback device as /devices/virtual/rc/rc0/input2
[    0.395717] rc rc0: lirc device registered as lirc0
[   12.612313] rc rc1: mceusb device as /devices/virtual/rc/rc1
[   12.612768] input: mceusb device as /devices/virtual/rc/rc1/input4
[   12.613112] rc rc1: lirc device registered as lirc1

(and we might want to change the lirc line to include the sysfs path?)

But realistically, how much dmesg grepping are we expecting normal
end-users to be doing?

Anyway, as I said, this patch isn't crucial, and we can revisit printk's
later (I'm looking at the ioctl locking right now and I think an
ir-lirc-codec and lirc_dev merger might be a good idea once the fate of
lirc_zilog has been decided).

>With the driver name I know which one is which.
>
>Maybe lirc_driver.name should be a "const char*" so no strcpy is needed
>(the ir-lirc-codec does not seem necessary).

Not that it really pertains to whether d->name should be kept or not,
but I think that lirc_dev shouldn't copy the lirc_driver struct into an
irctl struct internal copy at all, but just keep a normal pointer. I
haven't gotten around to vetting the (ab)use of the lirc_driver struct
yet though.

Regards,
David
