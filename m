Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2JAKme (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 06:42:34 -0400
Date: Mon, 1 Oct 2012 07:42:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: mkrufky@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tda18271-common: hold the I2C adapter during write
 transfers
Message-ID: <20121001074219.14ae1de0@redhat.com>
In-Reply-To: <5065ECEB.30807@iki.fi>
References: <20120928084337.1db94b8c@redhat.com>
	<1348844661-19114-1-git-send-email-mchehab@redhat.com>
	<5065ECEB.30807@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Sep 2012 21:31:07 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Hello,
> Did not fix the issue. Problem remains same.

Ok, that's what I was afraid: there's likely something at drxk firmware that 
it is needed for tda18271 to be visible - maybe gpio settings.

> With the sleep + that patch 
> it works still.

Good, no regressions added.

IMO, we should add a defer job at dvb_attach, that will postpone the
tuner attach to happen after drxk firmware is loaded, or add there a
wait queue. Still, I think that this patch is needed anyway, in order
to avoid race conditions with CI and Remote Controller polls that may
affect devices with tda18271.

It should be easy to check if the firmware is loaded: all it is needed
is to, for example, call:
	drxk_ops.get_tune_settings()

This function returns -ENODEV if firmware load fails; -EAGAIN if
firmware was not loaded yet and 0 or -EINVAL if firmware is OK.

So, instead of using sleep, you could do:

static bool is_drxk_firmware_loaded(struct dvb_frontend *fe) {
	struct dvb_frontend_tune_settings sets;
	int ret = fe->ops.get_tune_settings(fe, &sets);

	if (ret == -ENODEV || ret == -EAGAIN)
		return false;
	else
		return true;
};

and, at the place you coded the sleep(), replace it by:

	ret = wait_event_interruptible(waitq, is_drxk_firmware_loaded(dev->dvb->fe[0]));
	if (ret < 0) {
		dvb_frontend_detach(dev->dvb->fe[0]);
		dev->dvb->fe[0] = NULL;
		return -EINVAL;
	}

It might have sense to add an special callback to return the tuner
state (firmware not loaded, firmware loaded, firmware load failed).

Regards,
Mauro
