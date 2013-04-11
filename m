Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:55852 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3DKNk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 09:40:58 -0400
Received: by mail-qe0-f52.google.com with SMTP id jy17so878644qeb.25
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 06:40:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51666CA2.6080709@web.de>
References: <51650142.2060404@web.de>
	<51666CA2.6080709@web.de>
Date: Thu, 11 Apr 2013 09:40:57 -0400
Message-ID: <CAGoCfiyhKsxQ35tC9Ahy59p98QwX5GqORMfNtC6j9BYiaUYAzA@mail.gmail.com>
Subject: Re: uvcvideo: Dropping payload (out of sync)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 11, 2013 at 3:56 AM, André Weidemann <Andre.Weidemann@web.de> wrote:
> For anyone who may also run into this problem here is a solution...
>
> It seems the problem is hardware related to the Raspberry Pi. The solution
> can be found here:
>
> https://github.com/raspberrypi/linux/issues/238
> https://github.com/P33M/linux

Yup, it's been known for a while that the USB host controller on the
Raspberry Pi is absolute crap.  For all the great things about the Pi,
I would probably consider this it's biggest weakness (it's actually
prompted me to *not* use the Pi for several projects where I needed a
low-cost Linux platform)...

No easy answers here.  It just won't be a very good platform for
capturing uncompressed video over its USB port.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
