Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:30153 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab0L1ONe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 09:13:34 -0500
Subject: Re: [PATCH 0/8] Fix V4L/DVB/RC warnings
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4D195584.6020409@redhat.com>
References: <e95cvd7ycvmoq6jolupfigs0.1293494109547@email.android.com>
	 <4D195584.6020409@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 09:14:09 -0500
Message-ID: <1293545649.2728.28.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, 2010-12-28 at 01:12 -0200, Mauro Carvalho Chehab wrote:
> Em 27-12-2010 21:55, Andy Walls escreveu:
> > I have hardware for lirc_zilog.  I can look later this week.
> 
> That would be great!

It shouldn't be hard to fix up the lirc_zilog.c use of adap->id but it
may require a change to the hdpvr driver as well.

As I was looking, I noticed this commit is incomplete:

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=07cc65d4f4a21a104269ff7e4e7be42bd26d7acb

The "goto" was missed in the conditional compilation for the HD-PVR:

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/staging/lirc/lirc_zilog.c;h=f0076eb025f1a0e9d412080caab87f627dda4970#l844

You might want to revert the trivial commit that removed the "done:"
label.  When I clean up the dependence on adap->id, I may need the
"done:" label back again.



> > I also have hardware that lirc_i2c handles but not all the hardware it handles.
> > 
> >  IIRC lirc_i2c is very much like ir-kbd-i2c, so do we need it
> anymore?  I'm not able to check for myself at the moment.
> 
> Both ir-kbd-i2c and lirc_i2c have almost the same features. We need to
> double-check if all I2C addresses supported by lirc_i2c are also supported
> by ir-kbd-i2c and if all I2C chipsets are supported.

I'll modify lirc_i2c.c in three stages to do this:

1. get rid of adapter->id use
	- Trivial for I2C address 0x71 (the Zilog Z8F0811 chip's IR Rx)
	- Requires modifications to cx88 for the LeadTek PVR2000.
2. drop support for ir already handled by bridge drivers + ir-kbd-i2c
3. move support for remainders in lirc_i2c to ir-kbd-i2c and bridge
drivers

Regards,
Andy

> > 
> > Regards,
> > Andy
> > 
> > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > 
> >>
> >> There were several warnings at the subsystem, that were catched with
> >> gcc version 4.5.1. All of them are fixed on those patches by a 
> >> trivial patch. So, let's fix them ;)
> >>
> >> Now, the only remaining patches are the ones we want to be there:
> >>
> >> drivers/staging/lirc/lirc_i2c.c: In function ‘ir_probe’:
> >> drivers/staging/lirc/lirc_i2c.c:431:3: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
> >> drivers/staging/lirc/lirc_i2c.c:450:3: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
> >> drivers/staging/lirc/lirc_i2c.c:479:9: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
> >> drivers/staging/lirc/lirc_zilog.c: In function ‘ir_probe’:
> >> drivers/staging/lirc/lirc_zilog.c:1199:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
> >> drivers/media/video/cx88/cx88-i2c.c: In function ‘cx88_i2c_init’:
> >> drivers/media/video/cx88/cx88-i2c.c:149:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
> >> drivers/media/video/cx88/cx88-vp3054-i2c.c: In function ‘vp3054_i2c_probe’:
> >> drivers/media/video/cx88/cx88-vp3054-i2c.c:128:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
> >>
> >> They are basically caused by lirc_i2c and lirc_zilog, that still needs
> >> to use the legacy .id field at the I2C structs. Somebody with those
> >> hardware, please fix it.
> >>
> >> Thanks,
> >> Mauro
> >>
> >> -
> >>
> >> Mauro Carvalho Chehab (8):
> >>  [media] dmxdev: Fix a compilation warning due to a bad type
> >>  [media] radio-wl1273: Fix two warnings
> >>  [media] lirc_zilog: Fix a warning
> >>  [media] dib7000m/dib7000p: Add support for TRANSMISSION_MODE_4K
> >>  [media] gspca: Fix a warning for using len before filling it
> >>  [media] stv090x: Fix some compilation warnings
> >>  [media] af9013: Fix a compilation warning
> >>  [media] streamzap: Fix a compilation warning when compiled builtin
> >>
> >> drivers/media/dvb/dvb-core/dmxdev.c    |    4 ++--
> >> drivers/media/dvb/frontends/af9013.c   |    2 +-
> >> drivers/media/dvb/frontends/dib7000m.c |   10 +++++-----
> >> drivers/media/dvb/frontends/dib7000p.c |   10 +++++-----
> >> drivers/media/dvb/frontends/stv090x.c  |    6 +++---
> >> drivers/media/radio/radio-wl1273.c     |    3 +--
> >> drivers/media/rc/streamzap.c           |    2 +-
> >> drivers/media/video/gspca/gspca.c      |    2 +-
> >> drivers/staging/lirc/lirc_zilog.c      |    1 -
> >> 9 files changed, 19 insertions(+), 21 deletions(-)
> >>
> >> -- 
> >> 1.7.3.4
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 


