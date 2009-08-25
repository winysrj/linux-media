Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:65219 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbZHYWBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 18:01:41 -0400
Received: by fxm17 with SMTP id 17so2493939fxm.37
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 15:01:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A945CA4.6010402@iki.fi>
References: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com>
	 <200908041312.52878.jareguero@telefonica.net>
	 <8527bc070908041423p439f2d35y2e31014a10433c80@mail.gmail.com>
	 <200908042348.58148.jareguero@telefonica.net>
	 <4A945CA4.6010402@iki.fi>
Date: Tue, 25 Aug 2009 18:01:42 -0400
Message-ID: <829197380908251501l7731536bg79dd8595cd7ce50d@mail.gmail.com>
Subject: Re: Noisy video with Avermedia AVerTV Digi Volar X HD (AF9015) and
	mythbuntu 9.04
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	Cyril Hansen <cyril.hansen@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 25, 2009 at 5:50 PM, Antti Palosaari<crope@iki.fi> wrote:
> USB2.0 BULK stream .buffersize is currently 512 and your patch increases it
> to the 65424. I don't know how this value should be determined. I have set
> it as small as it is working and usually it is 512 used almost every driver.
> 511 will not work (if not USB1.1 configured to the endpoints).
>
> ****
>
> Could someone point out how correct BULK buffersize should be determined? I
> have thought that many many times...

Usually I do a sniffusb capture of the Windows driver and use whatever
they are using.

>
> ****
>
> Also one other question; if demod is powered off and some IOCTL is coming -
> like FE_GET_FRONTEND - how that should be handled? v4l-dvb -framework does
> not look whether or not demod is sleeping and forwards that query to the
> demod which cannot answer it.

In other demods, whenever the set_frontend call comes in the driver
check to see if the device is asleep and wakes it up on demand.  On
some demods, you can query a register to get the power state.  In
other cases you have to manually keep track of whether you previously
put the demod to sleep using the demod's state structure.

Chers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
