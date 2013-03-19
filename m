Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:35474 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab3CSU1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 16:27:55 -0400
Received: by mail-ea0-f177.google.com with SMTP id r16so437180ead.22
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2013 13:27:54 -0700 (PDT)
Message-ID: <5148CA46.3070104@gmail.com>
Date: Tue, 19 Mar 2013 21:27:50 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Anvesh Manne <anvesh.manne@polmon.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
	Andrey Gusakov <dron0gus@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: OV7670 driver for Mini2440
References: <F4AA40CF-883D-4E68-ADEB-827BF16F6498@polmon.com>
In-Reply-To: <F4AA40CF-883D-4E68-ADEB-827BF16F6498@polmon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anvesh,

On 03/19/2013 03:41 PM, Anvesh Manne wrote:
> Hello,

Cc linux-media mailing list.

> I am trying to get the OV7670 module to work with Mini2440. Despite my
> best efforts, i am ending with the following image.

OK, what kernel version and drivers are you currently using. Is it some
custom BSP or the Pengutronix's one ?

The image looks like there is a mismatch in configured pixel format at
the sensor and the s3c2440 CAMIF device.

> Can you guide me on how to install your driver from
> (http://git.linuxtv.org/snawrocki/media.git/commit/caa3b9af18f344ef9b21377f7dc4631bd6a99d19)
> along with the driver from http://patchwork.linuxtv.org/patch/563/ ?

There is already ov7670 sensor driver in the mainline kernel that
looks much better then the one from the link above. With a small
patch we should be able to use it with Mini2440.

If possible, I suggest you to use latest kernel that can be found here:
http://git.linuxtv.org/media_tree.git

> I have directly interfaced OV7670 to the Camera port of Mini2440.
>
> Thanks for you help.
>
> Anvesh

--

Regards,
Sylwester
