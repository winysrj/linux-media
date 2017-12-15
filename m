Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:41808 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755530AbdLOSkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 13:40:49 -0500
Received: by mail-wr0-f182.google.com with SMTP id p69so13068wrb.8
        for <linux-media@vger.kernel.org>; Fri, 15 Dec 2017 10:40:49 -0800 (PST)
Date: Fri, 15 Dec 2017 19:40:44 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, zzam@gentoo.org
Subject: Re: [PATCH] [media] tda18212: fix use-after-free in
 tda18212_remove()
Message-ID: <20171215194044.12dc4469@macbox>
In-Reply-To: <9d4e4ccd-9d96-b2eb-6b49-7f50dc08e109@iki.fi>
References: <20171215164337.3236-1-d.scheller.oss@gmail.com>
        <3c5e3614-ee61-f69a-283f-2c1b16aa2cbc@iki.fi>
        <20171215190008.1dde2633@macbox>
        <9d4e4ccd-9d96-b2eb-6b49-7f50dc08e109@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Dec 2017 20:12:18 +0200
Antti Palosaari <crope@iki.fi> wrote:

> On 12/15/2017 08:00 PM, Daniel Scheller wrote:
> > Hi,
> > 
> > On Fri, 15 Dec 2017 19:30:18 +0200
> > Antti Palosaari <crope@iki.fi> wrote:
> > 
> > Thanks for your reply.
> >   
> >> Hello
> >> I think shared frontend structure, which is owned by demod driver,
> >> should be there and valid on time tuner driver is removed. And thus
> >> should not happen. Did you make driver unload on different order
> >> eg. not just reverse order than driver load?
> >>
> >> IMHO these should go always
> >>
> >> on load:
> >> 1) load demod driver (which makes shared frontend structure where
> >> also some tuner driver data lives)
> >> 2) load tuner driver
> >> 3) register frontend
> >>
> >> on unload
> >> 1) unregister frontend
> >> 2) remove tuner driver
> >> 3) remove demod driver (frees shared data)  
> > 
> > In ddbridge, we do (like in usb/em28xx and platform/sti/c8sectpfe,
> > both also use some demod+tda18212 combo):
> > 
> > dvb_unregister_frontend();
> > dvb_frontend_detach();
> > module_put(tda18212client->...owner);
> > i2c_unregister_device(tda18212client);
> > 
> > fe_detach() clears out the frontend references and frees/invalidates
> > the allocated resources. tuner_ops obviously isn't there then
> > anymore.  
> 
> yeah, but that's even ideally wrong. frontend design currently relies
> to shared data which is owned by demod driver and thus it should be
> last thing to be removed. Sure change like you did prevents issue,
> but logically it is still wrong and may not work on some other case.
> 
> > 
> > The two mentioned drivers will very likely yield the same (or
> > similar) KASAN report. em28xx was even changed lately to do the
> > teardown the way ddbridge does in 910b0797fa9e8 ([1], cc'ing
> > Matthias here).
> > 
> > With that commit in mind I'm a bit unsure on what is correct or not.
> > OTOH, as dvb_frontend_detach() cleans up everything, IMHO there's no
> > need for the tuner driver to try to clean up further.
> > 
> > Please advise.
> > 
> > [1]
> > https://git.linuxtv.org/media_tree.git/commit/?id=910b0797fa9e8.  
> 
> em28xx does it currently just correct.
> 1) unregister frontend

Note that this is a call to em28xx_unregister_dvb(), which in turn does
dvb_unregister_frontend() and then dvb_frontend_detach() (at this
stage, fe resources are gone).

> 2) remove I2C SEC
> 3) remove I2C tuner
> 4) remove I2C demod (frees shared frontend data)

Yes, but ie. EM2874_BOARD_KWORLD_UB435Q_V3 is a combination of a
"legacy" demod frontend - lgdt3305 actually - plus the tda18212
i2cclient (just like in ddb with stv0367+tda18212 or
cxd2841er+tda18212), I'm sure this will yield the same report.

Maybe another approach: Implement the tuner_ops.release callback, and
then move the memset+NULL assignment right there (instead of just
removing it), but this likely will cause issues when the i2c client is
removed before detach if we don't keep track of this ie somewhere in
tda18212_dev (new state var - if _remove is called, check if the tuner
was released, and if not, call release (memset/set NULL), then
free). Still with the two other drivers in mind though. If they're
wrong aswell, I'll rather fix up ddbridge of course.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
