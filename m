Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:61420 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZBEH0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 02:26:23 -0500
Received: by yw-out-2324.google.com with SMTP id 9so35159ywe.1
        for <linux-media@vger.kernel.org>; Wed, 04 Feb 2009 23:26:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902041240.12121.dcurran@ti.com>
References: <200902041240.12121.dcurran@ti.com>
Date: Thu, 5 Feb 2009 08:26:21 +0100
Message-ID: <b0bb99640902042326w3a65be12l3bd53f2aee276dc9@mail.gmail.com>
Subject: Re: [REVIEW][PATCH] LV8093: Add driver for LV8093 lens actuator.
From: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>
To: Dominic Curran <dcurran@ti.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

2009/2/4 Dominic Curran <dcurran@ti.com>:
> The device has only one read register which contains a single BUSY bit.
> For large relative lens movements the device can be busy for sometime and we need
> to know when the lens has stopped moving.
>
> My question is what is the most appropriate mechanism to read the BUSY bit ?
>
> Currently the driver uses the VIDIOC_G_CTRL ioctl + V4L2_CID_FOCUS_RELATIVE ctrl
> ID to return the BUSY bit.  Is this acceptable ?

[...]

> A 3rd solution is to read the BUSY bit everytime after a write and not return
> until device is ready.  However this adds extra time to the operation
> (particularly for small lens moves) and I would like the user to be in change of
> when the reads of BUSY bit occur.

And what about waiting for not BUSY at the *beginning* of the next
lens adjustment if the previous one hasn't finished yet? This could be
combined with either a polling interface or a sync style interface
(wait for not BUSY function) for the case in which the user wants to
actually be sure that the lens got up to its target state.

Best regards,

   JJ.

-- 
Dream small if success is enough for you; dream big if you need to
change the world.
