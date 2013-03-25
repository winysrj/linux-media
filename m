Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4922 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab3CYJFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 05:05:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [GIT PULL FOR v3.10] au0828 driver overhaul
Date: Mon, 25 Mar 2013 10:05:41 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201303221738.16145.hverkuil@xs4all.nl> <20130324145117.48bdab45@redhat.com> <CAGoCfiyQFU6fe_S5LmHZ-+iSTiRG6Jy-tCRXuUSr3FvH2jLj_w@mail.gmail.com>
In-Reply-To: <CAGoCfiyQFU6fe_S5LmHZ-+iSTiRG6Jy-tCRXuUSr3FvH2jLj_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251005.41766.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 24 2013 18:55:50 Devin Heitmueller wrote:
> On Sun, Mar 24, 2013 at 1:51 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > drivers/media/dvb-frontends/au8522_decoder.c:static int au8522_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> > drivers/media/dvb-frontends/au8522_decoder.c-{
> > drivers/media/dvb-frontends/au8522_decoder.c-     int val = 0;
> > drivers/media/dvb-frontends/au8522_decoder.c-     struct au8522_state *state = to_state(sd);
> > drivers/media/dvb-frontends/au8522_decoder.c-     u8 lock_status;
> > drivers/media/dvb-frontends/au8522_decoder.c-
> > drivers/media/dvb-frontends/au8522_decoder.c-     /* Interrogate the decoder to see if we are getting a real signal */
> > drivers/media/dvb-frontends/au8522_decoder.c-     lock_status = au8522_readreg(state, 0x00);
> > drivers/media/dvb-frontends/au8522_decoder.c-     if (lock_status == 0xa2)
> > drivers/media/dvb-frontends/au8522_decoder.c-             vt->signal = 0xffff;
> > drivers/media/dvb-frontends/au8522_decoder.c-     else
> > drivers/media/dvb-frontends/au8522_decoder.c-             vt->signal = 0x00;
> > drivers/media/dvb-frontends/au8522_decoder.c-
> > drivers/media/dvb-frontends/au8522_decoder.c-     vt->capability |=
> > drivers/media/dvb-frontends/au8522_decoder.c-             V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LANG1 |
> > drivers/media/dvb-frontends/au8522_decoder.c-             V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
> > drivers/media/dvb-frontends/au8522_decoder.c-
> > drivers/media/dvb-frontends/au8522_decoder.c-     val = V4L2_TUNER_SUB_MONO;
> > drivers/media/dvb-frontends/au8522_decoder.c-     vt->rxsubchans = val;
> > drivers/media/dvb-frontends/au8522_decoder.c-     vt->audmode = V4L2_TUNER_MODE_STEREO;
> > drivers/media/dvb-frontends/au8522_decoder.c-     return 0;
> >
> > As if the i2c gate is on a wrong state, au8522_readreg() won't
> > work anymore.
> 
> Note that au8522_g_tuner function never actually talks to the tuner.
> It's handled entirely within the au8522 driver, which is not behind
> the gate.  The I2C gate is only required if talking to the xc5000, not
> the au8522.
> 
> There's something else broken here.  I suspect it's probably some
> artifact of the conversion to the new control framework (if I had to
> guess).

Rather than guessing I'll be doing some testing this week. It could also be
a crappy antenna connection as that's been giving me some grief lately (due
to an unholy BNC-to-F-connector-to-coax adapter chain).

Regards,

	Hans
