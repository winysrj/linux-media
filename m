Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2JAMhJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 08:37:09 -0400
Message-ID: <50698E67.5080400@redhat.com>
Date: Mon, 01 Oct 2012 09:36:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: mkrufky@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tda18271-common: hold the I2C adapter during write transfers
References: <20120928084337.1db94b8c@redhat.com> <1348844661-19114-1-git-send-email-mchehab@redhat.com> <5065ECEB.30807@iki.fi> <20121001074219.14ae1de0@redhat.com> <50697EFD.2080809@iki.fi>
In-Reply-To: <50697EFD.2080809@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-10-2012 08:31, Antti Palosaari escreveu:
> On 10/01/2012 01:42 PM, Mauro Carvalho Chehab wrote:
>> Em Fri, 28 Sep 2012 21:31:07 +0300
>> Antti Palosaari <crope@iki.fi> escreveu:
>>
>>> Hello,
>>> Did not fix the issue. Problem remains same.
>>
>> Ok, that's what I was afraid: there's likely something at drxk firmware that
>> it is needed for tda18271 to be visible - maybe gpio settings.
>>
>>> With the sleep + that patch
>>> it works still.
>>
>> Good, no regressions added.
> 
> Currently there is regression as you haven't committed that sleep patch.

Yes, I won't apply it before we finish those discussions.

>> IMO, we should add a defer job at dvb_attach, that will postpone the
>> tuner attach to happen after drxk firmware is loaded, or add there a
>> wait queue. Still, I think that this patch is needed anyway, in order
>> to avoid race conditions with CI and Remote Controller polls that may
>> affect devices with tda18271.
>>
>> It should be easy to check if the firmware is loaded: all it is needed
>> is to, for example, call:
>>     drxk_ops.get_tune_settings()
>>
>> This function returns -ENODEV if firmware load fails; -EAGAIN if
>> firmware was not loaded yet and 0 or -EINVAL if firmware is OK.
>>
>> So, instead of using sleep, you could do:
>>
>> static bool is_drxk_firmware_loaded(struct dvb_frontend *fe) {
>>     struct dvb_frontend_tune_settings sets;
>>     int ret = fe->ops.get_tune_settings(fe, &sets);
>>
>>     if (ret == -ENODEV || ret == -EAGAIN)
>>         return false;
>>     else
>>         return true;
>> };
>>
>> and, at the place you coded the sleep(), replace it by:
>>
>>     ret = wait_event_interruptible(waitq, is_drxk_firmware_loaded(dev->dvb->fe[0]));
>>     if (ret < 0) {
>>         dvb_frontend_detach(dev->dvb->fe[0]);
>>         dev->dvb->fe[0] = NULL;
>>         return -EINVAL;
>>     }
>>
>> It might have sense to add an special callback to return the tuner
>> state (firmware not loaded, firmware loaded, firmware load failed).
> 
> This is stupid approach. It does not change the original behavior which was we are not allowed to block module init path. 
> It blocks module init just as long as earlier, even longer, with increased code complexity!

Not really. em28xx-dvb is loaded/attached asynchronously, already:


static void request_module_async(struct work_struct *work)
{
	struct em28xx *dev = container_of(work,
			     struct em28xx, request_module_wk);

	if (dev->has_audio_class)
		request_module("snd-usb-audio");
	else if (dev->has_alsa_audio)
		request_module("em28xx-alsa");

	if (dev->board.has_dvb)
		request_module("em28xx-dvb");
	if (dev->board.ir_codes && !disable_ir)
		request_module("em28xx-rc");
}

static void request_modules(struct em28xx *dev)
{
	INIT_WORK(&dev->request_module_wk, request_module_async);
	schedule_work(&dev->request_module_wk);
}

(one small change there is actually needed, for the case where the
 driver is built-in)

> Why the hell you want add this kind of hacks every single chip driver that downloads firmware? Instead, put it to the bridge and leave demod, tuner, sec, etc, drivers free.

A sleep() hack is worse. Firmware load can take up to 60 seconds. 

Btw, I know one atom-based hardware where firmware load can actually 
take a lot more than 2 seconds to happen, when the root fs is mounted
via nfs.

> 
> If you put that asyncronous stuff to em28xx (with possible dev unregister if you wish to be elegant) then all the rest sub-drivers could be hack free.
> 
> regards
> Antti

