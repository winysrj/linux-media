Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:39947 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3KEU4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 15:56:48 -0500
Received: by mail-la0-f50.google.com with SMTP id eo20so3506463lab.23
        for <linux-media@vger.kernel.org>; Tue, 05 Nov 2013 12:56:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbxCjEWk47MkJP15QBAuGd3ePYS3ZRMduqdMCrVT362-8Q@mail.gmail.com>
References: <1383666180-9773-1-git-send-email-knightrider@are.ma>
	<CAOcJUbxCjEWk47MkJP15QBAuGd3ePYS3ZRMduqdMCrVT362-8Q@mail.gmail.com>
Date: Wed, 6 Nov 2013 05:56:46 +0900
Message-ID: <CAKnK8-Q51UOqGc1T2jfJENm5pOWAutytKLcDkhgkM3yWjAtJ2w@mail.gmail.com>
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T) cards
From: =?UTF-8?B?44G744Gh?= <knightrider@are.ma>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

see inline

2013/11/6 Michael Krufky <mkrufky@linuxtv.org>:
> responding inline:
>
>> Mauro Carvalho Chehab asked to put tuner code as an I2C driver, under drivers/media/tuners, frontends at drivers/media/dvb-
>> However, to keep package integrity & compatibility with PT1/PT2 user apps, FE etc. are still placed in the same directory.
>
> A userspace application doesn't care  where file are places within the
> kernel tree.  You are to use standard linux-dvb api's and the
> codingstyle of the driver shall comply with that of the linux kernel's
> DVB subsystem, including the proper placement of files.

As stated in my (previous) mails, I took PT1 module as a reference.
Everything is located in single directory ...pt1/, including the frontends.
They are built as a single integrated module, earth-pt1.ko

Sure I can split the FEs out to .../dvb-frontends/, build there as a separated
(FE only) module that would be hot-linked with the main module. However
I'm afraid (& sure) this will only make people confused with complex
dependencies leading to annoying bugs... The simpler the better...

Guys I need more opinions from other people before splitting the module.
IMHO even Linus won't like this...

>> diff --git a/drivers/media/pci/pt3_dvb/Kconfig b/drivers/media/pci/pt3_dvb/Kconfig
>> new file mode 100644
>> index 0000000..f9ba00d
>> --- /dev/null
>> +++ b/drivers/media/pci/pt3_dvb/Kconfig
>> @@ -0,0 +1,12 @@
>> +config PT3_DVB
>> +       tristate "Earthsoft PT3 cards"
>> +       depends on DVB_CORE && PCI
>> +       help
>> +         Support for Earthsoft PT3 PCI-Express cards.
>> +
>> +         Since these cards have no MPEG decoder onboard, they transmit
>> +         only compressed MPEG data over the PCI bus, so you need
>> +         an external software decoder to watch TV on your computer.
>> +
>> +         Say Y or M if you own such a device and want to use it.
>
> Very few of these digital tuner boards have onboard mpeg decoders.  We
> can do without this extra information here.

ok, will change to:
These cards transmit only compressed MPEG data over the PCI bus.
You need external software decoder to watch TV on your computer.

>> diff --git a/drivers/media/pci/pt3_dvb/Makefile b/drivers/media/pci/pt3_dvb/Makefile
>> new file mode 100644
>> index 0000000..7087c90
>> --- /dev/null
>> +++ b/drivers/media/pci/pt3_dvb/Makefile
>> @@ -0,0 +1,6 @@
>> +pt3_dvb-objs := pt3.o pt3_fe.o pt3_dma.o pt3_tc.o pt3_i2c.o pt3_bus.o
>> +
>> +obj-$(CONFIG_PT3_DVB) += pt3_dvb.o
>> +
>> +ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
>> +
>
> Ususally, the driver would be named 'pt3.ko' and the object file that
> handles the DVB api would be called pt3_dvb.o
>
> This isn't any rule, but the way that you've named them seems a bit
> awkward to me.  I don't require that you change this, just stating my
> awkward feeling on the matter.

FYI, there is another version of PT3 driver, named pt3_drv.ko, that
utilize character devices as the I/O. I'd rather use pt3_dvb.ko to
distinguish.

Maybe I'd like to change the dirname:
drivers/media/pci/pt3_dvb => drivers/media/pci/pt3

>> +static int lnb = 2;    /* used if not set by frontend / the value is invalid */
>> +module_param(lnb, int, 0);
>> +MODULE_PARM_DESC(lnb, "LNB level (0:OFF 1:+11V 2:+15V)");
>
> Take these above three statements out of the header file and move them
> into a .c file

OK Sir

>> +struct dvb_frontend *pt3_fe_s_attach(struct pt3_adapter *adap);
>> +struct dvb_frontend *pt3_fe_t_attach(struct pt3_adapter *adap);
>
> Please create separate headers corresponding to the .c file that
> contains the function.  Don't put them all in one, as the tuner and
> demodulator should be separate modules

Splitting the protos? Well I will consider...

> every source file and header file should include GPLv2 license headers.

Roger: not very crucial though...

>> +#define PT3_QM_INIT_DUMMY_RESET 0x0c
>
> it's nicer when these macros are defined in one place, but its not a
> requirement.  It's OK to leave it here if you really want to, but I
> suggest instead to create a _reg.h file containing all register
> #defines

Will consider...
