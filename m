Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36755 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0ANMZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 07:25:07 -0500
Received: by yxe17 with SMTP id 17so23308824yxe.33
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 04:25:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <eedb5541001132328w3e1f1a4dj48e20bbad63acf96@mail.gmail.com>
References: <1260885686-8478-1-git-send-email-acassis@gmail.com>
	 <37367b3a0912150607v713edc32y3578fa2a0c8c61db@mail.gmail.com>
	 <eedb5541001032340n66205fb8s57e09d2ba413b322@mail.gmail.com>
	 <37367b3a1001040412k280f3366p4868e36f5a7f71e4@mail.gmail.com>
	 <eedb5541001040425h2a3c07dcn534c71a0918b322b@mail.gmail.com>
	 <eedb5541001040431j3f14ec55g66ed4dd44a2a840e@mail.gmail.com>
	 <37367b3a1001131033u74c30ad6q8da1dbc35982e008@mail.gmail.com>
	 <eedb5541001132328w3e1f1a4dj48e20bbad63acf96@mail.gmail.com>
Date: Thu, 14 Jan 2010 10:25:06 -0200
Message-ID: <37367b3a1001140425g1dbb0dcfu3e771ef6d488e9e2@mail.gmail.com>
Subject: Re: [PATCH] RFC: mx27: Add soc_camera support
From: Alan Carvalho de Assis <acassis@gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	mchehab@infradead.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 1/14/10, javier Martin <javier.martin@vista-silicon.com> wrote:
> No idea what can be causing this. Maybe I2C address is bad in board specific
> code?
>

I don't know, I will check carefully.

>> Linux video capture interface: v2.00
>> write: -5
>> MT9T31 Read register 0xFF = -5
>> Forcing mt9t031_video_probe to return OK!
>> mx27-camera mx27-camera.0: initialising
>> mx27-camera: probe of mx27-camera.0 failed with error -2
>>
>
> As far as I know, video buffers are allocated in probe() function. Maybe you
> have a memory fragmentation problem and you need to move buffer allocation
> to init().
> We have faced this problem many times in the past.
>

Hmm, great Javier, in fact it could be the issue!

Thank you very much.

Best Regards,

Alan
