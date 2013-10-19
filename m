Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39188 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3JSJzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Oct 2013 05:55:04 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so2541897eek.8
        for <linux-media@vger.kernel.org>; Sat, 19 Oct 2013 02:55:03 -0700 (PDT)
Message-ID: <5262570E.1020707@googlemail.com>
Date: Sat, 19 Oct 2013 11:55:26 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: make sure that all subdevices are powered on
 when needed
References: <1381952506-2405-1-git-send-email-fschaefer.oss@googlemail.com> <Pine.LNX.4.64.1310182228130.12288@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1310182228130.12288@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.10.2013 22:30, schrieb Guennadi Liakhovetski:
> Hi Frank
>
> Thanks for the patch
>
> On Wed, 16 Oct 2013, Frank Schäfer wrote:
>
>> Commit 622b828ab7 ("v4l2_subdev: rename tuner s_standby operation to
>> core s_power") replaced the tuner s_standby call in the em28xx driver with
>> a (s_power, 0) call which suspends all subdevices.
>> But it neglected to add corresponding (s_power, 1) calls to make sure that
>> the subdevices are powered on again when needed.
>>
>> This patch fixes this issue by adding a (s_power, 1) call to
>> function em28xx_wake_i2c().
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-core.c |    1 +
>>  1 Datei geändert, 1 Zeile hinzugefügt(+)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
>> index fc157af..8896789 100644
>> --- a/drivers/media/usb/em28xx/em28xx-core.c
>> +++ b/drivers/media/usb/em28xx/em28xx-core.c
>> @@ -1243,6 +1243,7 @@ EXPORT_SYMBOL_GPL(em28xx_init_usb_xfer);
>>   */
>>  void em28xx_wake_i2c(struct em28xx *dev)
>>  {
>> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  s_power, 1);
>>  	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
>>  	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
>>  			INPUT(dev->ctl_input)->vmux, 0, 0);
> Do I understand it right, that you're proposing this as an alternative to 
> my power-balancing patch?
Yes.
Your patch was nevertheless useful, because it pointed out further bugs
in em28xx_v4l2_open().
I've sent another RFC patch which should fix them, too.

>  It's certainly smaller and simpler, have you 
> also tested it with the ov2640 and my clock patches to see, whether this 
> really balances calls to .s_power() perfectly?
Yes, I've tested the patch with the VAD Laplace webcam (ov2640), a
Hauppauge HVR 900 and a Terratec Cinergy 200.
Please note that the patch does not balance .s_power() calls perfectly,
it only makes sure that the subdevices are powered on when needed.
This also avoids the scary v4l2-clk warnings.
Due to the various GPIO sequences, I see no chance to make s_power calls
really balanced in such drivers.

Regards,
Frank

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

