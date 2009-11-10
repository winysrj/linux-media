Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53672 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZKJMkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 07:40:05 -0500
Received: by bwz27 with SMTP id 27so4465895bwz.21
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 04:40:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b40acdb70911100426w46119c79y4226088ca3196254@mail.gmail.com>
References: <921ad39e0911100419p3ca39ea4ycd5ac84322555fc2@mail.gmail.com>
	 <b40acdb70911100426w46119c79y4226088ca3196254@mail.gmail.com>
Date: Tue, 10 Nov 2009 12:40:08 +0000
Message-ID: <921ad39e0911100440v6f146d1ci5858517cffdc0457@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_tw68=2Dv2=2Ftw68=2Di2c=2Ec=3A145=3A_error=3A_unknown_field_=E2=80=98?=
	=?UTF-8?Q?client=5Fregister=E2=80=99_specified_in_initializer?=
From: Roman Gaufman <hackeron@gmail.com>
To: Domenico Andreoli <cavokz@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, managed to compile but getting -1 Unknown symbol in module now
- any ideas?

# make
make -C /lib/modules/2.6.31-14-generic/build M=/root/tw68-v2 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.31-14-generic'
  CC [M]  /root/tw68-v2/tw68-core.o
  CC [M]  /root/tw68-v2/tw68-cards.o
  CC [M]  /root/tw68-v2/tw68-video.o
  CC [M]  /root/tw68-v2/tw68-controls.o
  CC [M]  /root/tw68-v2/tw68-fileops.o
  CC [M]  /root/tw68-v2/tw68-ioctls.o
  CC [M]  /root/tw68-v2/tw68-vbi.o
  CC [M]  /root/tw68-v2/tw68-ts.o
  CC [M]  /root/tw68-v2/tw68-risc.o
  CC [M]  /root/tw68-v2/tw68-input.o
  CC [M]  /root/tw68-v2/tw68-tvaudio.o
  LD [M]  /root/tw68-v2/tw68.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /root/tw68-v2/tw68.mod.o
  LD [M]  /root/tw68-v2/tw68.ko
make[1]: Leaving directory `/usr/src/linux-headers-2.6.31-14-generic'
# insmod tw68.ko
insmod: error inserting 'tw68.ko': -1 Unknown symbol in module
# uname -a
Linux xanview-dev 2.6.31-14-generic #48-Ubuntu SMP Fri Oct 16 14:05:01
UTC 2009 x86_64 GNU/Linux


2009/11/10 Domenico Andreoli <cavokz@gmail.com>:
> Hi,
>
> On Tue, Nov 10, 2009 at 1:19 PM, Roman Gaufman <hackeron@gmail.com> wrote:
>> Hey, I'm trying to compile tw68 and I'm getting the following:
>>
>> make -C /lib/modules/2.6.31-14-generic/build M=/root/tw68-v2 modules
>> make[1]: Entering directory `/usr/src/linux-headers-2.6.31-14-generic'
>>  CC [M]  /root/tw68-v2/tw68-core.o
>>  CC [M]  /root/tw68-v2/tw68-cards.o
>>  CC [M]  /root/tw68-v2/tw68-i2c.o
>> /root/tw68-v2/tw68-i2c.c:145: error: unknown field ‘client_register’
>> specified in initializer
>> /root/tw68-v2/tw68-i2c.c:145: warning: missing braces around initializer
>> /root/tw68-v2/tw68-i2c.c:145: warning: (near initialization for
>> ‘tw68_adap_sw_template.dev_released’)
>> /root/tw68-v2/tw68-i2c.c:145: warning: initialization makes integer
>> from pointer without a cast
>> /root/tw68-v2/tw68-i2c.c:145: error: initializer element is not
>> computable at load time
>> /root/tw68-v2/tw68-i2c.c:145: error: (near initialization for
>> ‘tw68_adap_sw_template.dev_released.done’)
>> make[2]: *** [/root/tw68-v2/tw68-i2c.o] Error 1
>> make[1]: *** [_module_/root/tw68-v2] Error 2
>> make[1]: Leaving directory `/usr/src/linux-headers-2.6.31-14-generic'
>> make: *** [all] Error 2
>>
>> Any ideas?
>
> yes, the i2c part got outdated by some kernel change. anyway it is still
> not used so you can safely remove tw68-i2c.c from Makefile.
>
> regards,
> Domenico
>
> -----[ Domenico Andreoli, aka cavok
>  --[ http://www.dandreoli.com/gpgkey.asc
>   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
>
