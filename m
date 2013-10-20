Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:44566 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3JTQ3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Oct 2013 12:29:00 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so3033349eek.24
        for <linux-media@vger.kernel.org>; Sun, 20 Oct 2013 09:28:59 -0700 (PDT)
Message-ID: <526404E3.2070108@googlemail.com>
Date: Sun, 20 Oct 2013 18:29:23 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: make sure that all subdevices are powered on
 when needed
References: <1381952506-2405-1-git-send-email-fschaefer.oss@googlemail.com> <Pine.LNX.4.64.1310182228130.12288@axis700.grange> <5262570E.1020707@googlemail.com> <Pine.LNX.4.64.1310191806060.19376@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1310191806060.19376@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Am 19.10.2013 18:32, schrieb Guennadi Liakhovetski:
> Hi Frank
>
> On Sat, 19 Oct 2013, Frank Schäfer wrote:
>
>> Am 18.10.2013 22:30, schrieb Guennadi Liakhovetski:
>>> Hi Frank
>>>
>>> Thanks for the patch
>>>
>>> On Wed, 16 Oct 2013, Frank Schäfer wrote:
>>>
>>>> Commit 622b828ab7 ("v4l2_subdev: rename tuner s_standby operation to
>>>> core s_power") replaced the tuner s_standby call in the em28xx driver with
>>>> a (s_power, 0) call which suspends all subdevices.
>>>> But it neglected to add corresponding (s_power, 1) calls to make sure that
>>>> the subdevices are powered on again when needed.
>>>>
>>>> This patch fixes this issue by adding a (s_power, 1) call to
>>>> function em28xx_wake_i2c().
>>>>
>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>> ---
>>>>  drivers/media/usb/em28xx/em28xx-core.c |    1 +
>>>>  1 Datei geändert, 1 Zeile hinzugefügt(+)
>>>>
>>>> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
>>>> index fc157af..8896789 100644
>>>> --- a/drivers/media/usb/em28xx/em28xx-core.c
>>>> +++ b/drivers/media/usb/em28xx/em28xx-core.c
>>>> @@ -1243,6 +1243,7 @@ EXPORT_SYMBOL_GPL(em28xx_init_usb_xfer);
>>>>   */
>>>>  void em28xx_wake_i2c(struct em28xx *dev)
>>>>  {
>>>> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  s_power, 1);
>>>>  	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
>>>>  	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
>>>>  			INPUT(dev->ctl_input)->vmux, 0, 0);
>>> Do I understand it right, that you're proposing this as an alternative to 
>>> my power-balancing patch?
>> Yes.
>> Your patch was nevertheless useful, because it pointed out further bugs
>> in em28xx_v4l2_open().
>> I've sent another RFC patch which should fix them, too.
>>
>>>  It's certainly smaller and simpler, have you 
>>> also tested it with the ov2640 and my clock patches to see, whether this 
>>> really balances calls to .s_power() perfectly?
>> Yes, I've tested the patch with the VAD Laplace webcam (ov2640), a
>> Hauppauge HVR 900 and a Terratec Cinergy 200.
>> Please note that the patch does not balance .s_power() calls perfectly,
>> it only makes sure that the subdevices are powered on when needed.
>> This also avoids the scary v4l2-clk warnings.
> hmm, I'm not sure I quite understand - calls aren't balanced perfectly, 
> but warnings are gone? Since warnings are gone, this means the use-count 
> doesn't go negative.
Correct.

>  Does that mean, that now you enable the clock more 
> often, then you disable it? 
(s_power, 1) is called more often than (s_power, 0).

> Wouldn't it lock the driver module in the 
> kernel via excessive module_get()? Or have I misunderstood something?
I don't know. Wouldn't this be a bug ?

>> Due to the various GPIO sequences, I see no chance to make s_power calls
>> really balanced in such drivers.
> I think those should be fixed actually. If there are indeed GPIO 
> operations, that switch subdevice power on and off, they should be coded 
> as such, perhaps as regulators.
Sure, that's how it _should_ be.
Care to fix the em28xx driver ? Do you have all the 90+ devices ? Do you
have time enough time to figure out/investigate their GPIO port
assignments and test them all ?

The em28xx driver is very old (~10 years ?) and other drivers are even
older.
Nobody cared about the GPIO details these days and there were also no
appropriate APIs for things like power control.
I agree that it would be nice to get things right, but I see no
realistic chance to achieve that.

>  And - as discussed elsewhere - actually 
> subdevice drivers should decide when power should be supplied to them, and 
> when not.
I still disagree in this point.
IMHO, this decision should be left to the master device that controls
the subdevice.

> Anyway, if your patch keeps the clock use count between 0 when unused and 
> 1, when used, I vote for it and would suggest to apply these fixes to 
> em28xx.
Apparently soc_camera calls v4l2_clk_enable() each time (s_power, 1) is
called.
Because s_power can't be balanced, v4l2_clk_enable()/disable() calls
aren't balanced, too. :/
This issue needs to be addressed indeed.

Regards,
Frank

>  Mauro, can we do this? Shall we repost the set to make it easier?
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

