Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:1154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab0L1DMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 22:12:30 -0500
Message-ID: <4D195584.6020409@redhat.com>
Date: Tue, 28 Dec 2010 01:12:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/8] Fix V4L/DVB/RC warnings
References: <e95cvd7ycvmoq6jolupfigs0.1293494109547@email.android.com>
In-Reply-To: <e95cvd7ycvmoq6jolupfigs0.1293494109547@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 27-12-2010 21:55, Andy Walls escreveu:
> I have hardware for lirc_zilog.  I can look later this week.

That would be great!

> I also have hardware that lirc_i2c handles but not all the hardware it handles.
> 
>  IIRC lirc_i2c is very much like ir-kbd-i2c, so do we need it anymore?  I'm not able to check for myself at the moment.

Both ir-kbd-i2c and lirc_i2c have almost the same features. We need to
double-check if all I2C addresses supported by lirc_i2c are also supported
by ir-kbd-i2c and if all I2C chipsets are supported.

> 
> Regards,
> Andy
> 
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>>
>> There were several warnings at the subsystem, that were catched with
>> gcc version 4.5.1. All of them are fixed on those patches by a 
>> trivial patch. So, let's fix them ;)
>>
>> Now, the only remaining patches are the ones we want to be there:
>>
>> drivers/staging/lirc/lirc_i2c.c: In function ‘ir_probe’:
>> drivers/staging/lirc/lirc_i2c.c:431:3: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
>> drivers/staging/lirc/lirc_i2c.c:450:3: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
>> drivers/staging/lirc/lirc_i2c.c:479:9: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
>> drivers/staging/lirc/lirc_zilog.c: In function ‘ir_probe’:
>> drivers/staging/lirc/lirc_zilog.c:1199:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
>> drivers/media/video/cx88/cx88-i2c.c: In function ‘cx88_i2c_init’:
>> drivers/media/video/cx88/cx88-i2c.c:149:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
>> drivers/media/video/cx88/cx88-vp3054-i2c.c: In function ‘vp3054_i2c_probe’:
>> drivers/media/video/cx88/cx88-vp3054-i2c.c:128:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
>>
>> They are basically caused by lirc_i2c and lirc_zilog, that still needs
>> to use the legacy .id field at the I2C structs. Somebody with those
>> hardware, please fix it.
>>
>> Thanks,
>> Mauro
>>
>> -
>>
>> Mauro Carvalho Chehab (8):
>>  [media] dmxdev: Fix a compilation warning due to a bad type
>>  [media] radio-wl1273: Fix two warnings
>>  [media] lirc_zilog: Fix a warning
>>  [media] dib7000m/dib7000p: Add support for TRANSMISSION_MODE_4K
>>  [media] gspca: Fix a warning for using len before filling it
>>  [media] stv090x: Fix some compilation warnings
>>  [media] af9013: Fix a compilation warning
>>  [media] streamzap: Fix a compilation warning when compiled builtin
>>
>> drivers/media/dvb/dvb-core/dmxdev.c    |    4 ++--
>> drivers/media/dvb/frontends/af9013.c   |    2 +-
>> drivers/media/dvb/frontends/dib7000m.c |   10 +++++-----
>> drivers/media/dvb/frontends/dib7000p.c |   10 +++++-----
>> drivers/media/dvb/frontends/stv090x.c  |    6 +++---
>> drivers/media/radio/radio-wl1273.c     |    3 +--
>> drivers/media/rc/streamzap.c           |    2 +-
>> drivers/media/video/gspca/gspca.c      |    2 +-
>> drivers/staging/lirc/lirc_zilog.c      |    1 -
>> 9 files changed, 19 insertions(+), 21 deletions(-)
>>
>> -- 
>> 1.7.3.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥

