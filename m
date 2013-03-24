Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab3CXRvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 13:51:24 -0400
Date: Sun, 24 Mar 2013 14:51:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.10] au0828 driver overhaul
Message-ID: <20130324145117.48bdab45@redhat.com>
In-Reply-To: <CAGoCfiwjF-C_sbivVi_+JST32BykFXSnKzpmZ0q5W3H-pGOzsw@mail.gmail.com>
References: <201303221738.16145.hverkuil@xs4all.nl>
	<CAGoCfiwjF-C_sbivVi_+JST32BykFXSnKzpmZ0q5W3H-pGOzsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Mar 2013 14:50:28 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Fri, Mar 22, 2013 at 12:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > It works fine with qv4l2, but there is still a bug causing tvtime to fail.
> > That's caused by commit e58071f024aa337b7ce41682578b33895b024f8b, applied
> > August last year, that broke g_tuner: after that 'signal' would always be 0
> > and tvtime expects signal to be non-zero for a valid frequency. 

I don't think so: tvtime has a way to either honor signal or to ignore it
via GUI. As there are tuners that can't provide any signal level, I suspect
that this is the reason why it was coded this way.

> > The signal
> > field is set by the au8522, but g_tuner is only called for the tuner (well,
> > also for au8522 but since the i2c gate is set for the tuner that won't do
> > anything).

As far as I remember, there are a few drivers or boards whose signal
information is provided by the bridge and not by the tuner. I think
that this still works. For example:

drivers/media/pci/bt8xx/bttv-driver.c:static int bttv_g_tuner(struct file *file, void *priv,
drivers/media/pci/bt8xx/bttv-driver.c-                            struct v4l2_tuner *t)
drivers/media/pci/bt8xx/bttv-driver.c-{
drivers/media/pci/bt8xx/bttv-driver.c-    struct bttv_fh *fh = priv;
drivers/media/pci/bt8xx/bttv-driver.c-    struct bttv *btv = fh->btv;
drivers/media/pci/bt8xx/bttv-driver.c-
drivers/media/pci/bt8xx/bttv-driver.c-    if (0 != t->index)
drivers/media/pci/bt8xx/bttv-driver.c-            return -EINVAL;
drivers/media/pci/bt8xx/bttv-driver.c-
drivers/media/pci/bt8xx/bttv-driver.c-    t->rxsubchans = V4L2_TUNER_SUB_MONO;
drivers/media/pci/bt8xx/bttv-driver.c-    t->capability = V4L2_TUNER_CAP_NORM;
drivers/media/pci/bt8xx/bttv-driver.c-    bttv_call_all(btv, tuner, g_tuner, t);
drivers/media/pci/bt8xx/bttv-driver.c-    strcpy(t->name, "Television");
drivers/media/pci/bt8xx/bttv-driver.c-    t->type       = V4L2_TUNER_ANALOG_TV;
drivers/media/pci/bt8xx/bttv-driver.c-    if (btread(BT848_DSTATUS)&BT848_DSTATUS_HLOC)
drivers/media/pci/bt8xx/bttv-driver.c-            t->signal = 0xffff;
drivers/media/pci/bt8xx/bttv-driver.c-
drivers/media/pci/bt8xx/bttv-driver.c-    if (btv->audio_mode_gpio)
drivers/media/pci/bt8xx/bttv-driver.c-            btv->audio_mode_gpio(btv, t, 0);
drivers/media/pci/bt8xx/bttv-driver.c-
drivers/media/pci/bt8xx/bttv-driver.c-    return 0;

changeset e58071f024aa337b7ce41682578b33895b024f8b doesn't affect it.

> Wait, are you saying that the G_TUNER call is no longer being routed
> to the au8522 driver?  The signal level has always been set to a
> nonzero value by au8522 if a signal is present, and thus the state of
> the i2c gate isn't relevant.

The logic there seems to need a proper I2C gate setting:

drivers/media/dvb-frontends/au8522_decoder.c:static int au8522_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
drivers/media/dvb-frontends/au8522_decoder.c-{
drivers/media/dvb-frontends/au8522_decoder.c-     int val = 0;
drivers/media/dvb-frontends/au8522_decoder.c-     struct au8522_state *state = to_state(sd);
drivers/media/dvb-frontends/au8522_decoder.c-     u8 lock_status;
drivers/media/dvb-frontends/au8522_decoder.c-
drivers/media/dvb-frontends/au8522_decoder.c-     /* Interrogate the decoder to see if we are getting a real signal */
drivers/media/dvb-frontends/au8522_decoder.c-     lock_status = au8522_readreg(state, 0x00);
drivers/media/dvb-frontends/au8522_decoder.c-     if (lock_status == 0xa2)
drivers/media/dvb-frontends/au8522_decoder.c-             vt->signal = 0xffff;
drivers/media/dvb-frontends/au8522_decoder.c-     else
drivers/media/dvb-frontends/au8522_decoder.c-             vt->signal = 0x00;
drivers/media/dvb-frontends/au8522_decoder.c-
drivers/media/dvb-frontends/au8522_decoder.c-     vt->capability |=
drivers/media/dvb-frontends/au8522_decoder.c-             V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LANG1 |
drivers/media/dvb-frontends/au8522_decoder.c-             V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
drivers/media/dvb-frontends/au8522_decoder.c-
drivers/media/dvb-frontends/au8522_decoder.c-     val = V4L2_TUNER_SUB_MONO;
drivers/media/dvb-frontends/au8522_decoder.c-     vt->rxsubchans = val;
drivers/media/dvb-frontends/au8522_decoder.c-     vt->audmode = V4L2_TUNER_MODE_STEREO;
drivers/media/dvb-frontends/au8522_decoder.c-     return 0;

As if the i2c gate is on a wrong state, au8522_readreg() won't
work anymore.

> This is because the xc5000 driver didn't
> actually have implemented a call to return the signal level.
> 
> If what you're saying is true, then the behavior of the framework
> itself changed, and who knows what else is broken.

I don't think that the framework behavior has changed with that
regards.

Anyway, until we have this issue fixed, I'll mark this patch
as "changes requested".

Regards,
Mauro
