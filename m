Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47114 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3DSSly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 14:41:54 -0400
Received: by mail-pd0-f172.google.com with SMTP id 5so2375749pdd.17
        for <linux-media@vger.kernel.org>; Fri, 19 Apr 2013 11:41:53 -0700 (PDT)
Subject: Re: OV7670 driver for Mini2440
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Anvesh Manne <anvesh.manne@polmon.com>
In-Reply-To: <5148CA46.3070104@gmail.com>
Date: Sat, 20 Apr 2013 00:11:41 +0530
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
	Andrey Gusakov <dron0gus@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <FB5D8129-77A9-4AA8-AD2B-3C156A1DFACA@polmon.com>
References: <F4AA40CF-883D-4E68-ADEB-827BF16F6498@polmon.com> <5148CA46.3070104@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sorry the extreme delay in replying..

I using BSP from friendly arm. 

SInce i am new to embedded linux, can you tell me how to install a 0v7670 driver for mini2440?

I currently modified the v4l2 driver(for ov9650) written by Vladimir (http://code.google.com/p/s3c2440camera/) to suit the 0v7670. But i am not able to get a perfect image from the camera. Can you point me to tried and test v4l2 driver for 7670?

Thanks,
Anvesh

On 20-Mar-2013, at 1:57 AM, Sylwester Nawrocki wrote:

> Hi Anvesh,
> 
> On 03/19/2013 03:41 PM, Anvesh Manne wrote:
>> Hello,
> 
> Cc linux-media mailing list.
> 
>> I am trying to get the OV7670 module to work with Mini2440. Despite my
>> best efforts, i am ending with the following image.
> 
> OK, what kernel version and drivers are you currently using. Is it some
> custom BSP or the Pengutronix's one ?
> 
> The image looks like there is a mismatch in configured pixel format at
> the sensor and the s3c2440 CAMIF device.
> 
>> Can you guide me on how to install your driver from
>> (http://git.linuxtv.org/snawrocki/media.git/commit/caa3b9af18f344ef9b21377f7dc4631bd6a99d19)
>> along with the driver from http://patchwork.linuxtv.org/patch/563/ ?
> 
> There is already ov7670 sensor driver in the mainline kernel that
> looks much better then the one from the link above. With a small
> patch we should be able to use it with Mini2440.
> 
> If possible, I suggest you to use latest kernel that can be found here:
> http://git.linuxtv.org/media_tree.git
> 
>> I have directly interfaced OV7670 to the Camera port of Mini2440.
>> 
>> Thanks for you help.
>> 
>> Anvesh
> 
> --
> 
> Regards,
> Sylwester

