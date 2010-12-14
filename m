Return-path: <mchehab@gaivota>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:35362 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab0LNKGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 05:06:12 -0500
Received: by ewy10 with SMTP id 10so226410ewy.4
        for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 02:06:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D073F83.8010301@redhat.com>
References: <4D073F83.8010301@redhat.com>
Date: Tue, 14 Dec 2010 05:06:10 -0500
Message-ID: <AANLkTimuS+O1rv1GL_ujj4D=gSXw+VLKh0vMc2mXx1Cd@mail.gmail.com>
Subject: Re: Hauppauge USB Live 2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, Dec 14, 2010 at 4:57 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>  Hi folks,
>
> Got a "Hauppauge USB Live 2" after google found me that there is a linux
> driver for it.  Unfortunaly linux doesn't manage to initialize the device.
>
> I've connected the device to a Thinkpad T60.  It runs a 2.6.37-rc5 kernel
> with the linuxtv/staging/for_v2.6.38 branch merged in.
>
> Kernel log and lsusb output are attached.
>
> Ideas anyone?

Looks like a regression got introduced since I submitted the original
support for the device.

Mauro?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
