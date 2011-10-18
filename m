Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1JRQjt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 12:39:49 -0400
Message-ID: <4E9DABA3.1070609@redhat.com>
Date: Tue, 18 Oct 2011 14:38:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Piotr Chmura <chmooreck@poczta.onet.pl>,
	devel@driverdev.osuosl.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/14] staging/media/as102: initial import from Abilis
References: <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl> <4E99F2FC.5030200@poczta.onet.pl> <20111016105731.09d66f03@stein> <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com> <4E9ADFAE.8050208@redhat.com> <20111018094647.d4982eb2.chmooreck@poczta.onet.pl> <20111018111134.8482d1f8.chmooreck@poczta.onet.pl> <20111018162423.GA24215@longonot.mountain>
In-Reply-To: <20111018162423.GA24215@longonot.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-10-2011 14:24, Dan Carpenter escreveu:
> On Tue, Oct 18, 2011 at 11:11:34AM +0200, Piotr Chmura wrote:
>> diff --git linux/drivers/staging/media/as102/Kconfig linuxb/drivers/media/dvb/as102/Kconfig
>> new file mode 100644
>> --- /dev/null
>> +++ linuxb/drivers/staging/media/as102/Kconfig
>> @@ -0,0 +1,7 @@
>> +config DVB_AS102
>> +	tristate "Abilis AS102 DVB receiver"
>> +	depends on DVB_CORE && USB && I2C && INPUT
>> +	help
>> +	  Choose Y or M here if you have a device containing an AS102
>> +
>> +	  To compile this driver as a module, choose M here
>> diff --git linux/drivers/staging/media/as102/Makefile linuxb/drivers/media/dvb/as102/Makefile
>> new file mode 100644
>> --- /dev/null
>> +++ linuxb/drivers/staging/media/as102/Makefile
>> @@ -0,0 +1,5 @@
>> +dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o as102_fe.o as102_usb_drv.o as10x_cmd_cfg.o
>> +
>> +obj-$(CONFIG_DVB_AS102) += dvb-as102.o
>> +
>> +EXTRA_CFLAGS += -DLINUX -DCONFIG_AS102_USB -Idrivers/media/dvb/dvb-core
> 
> It sounds like you're going to do a resend to add in the
> Signed-off-by lines?
> 
> It would be better to separate these two chunks out and put them at
> the end after you've fixed the compile errors in [PATCH 13/14].

This doesn't really matter, as the driver won't be added to the Kernel building system
before patch 13/14, as drivers/staging/Makefile wasn't touch on patch 1/14.
> 
> regards,
> dan carpenter

