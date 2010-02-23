Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62782 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0BWI37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 03:29:59 -0500
Received: by gwj16 with SMTP id 16so395110gwj.19
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 00:29:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f535cc5a1002230019u214f48e8n165ebcb54a0be198@mail.gmail.com>
References: <6e8e83e21002222329n30941317v2c8abda1866d6a98@mail.gmail.com>
	 <f535cc5a1002230019u214f48e8n165ebcb54a0be198@mail.gmail.com>
Date: Tue, 23 Feb 2010 16:29:58 +0800
Message-ID: <6e8e83e21002230029y11054c56w5c942f8f2401a9ae@mail.gmail.com>
Subject: Re: modprobe em28xx failed for MSI Vox II USB
From: Bee Hock Goh <beehock@gmail.com>
To: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carlos,

Thanks for the reply. Actually your usb stick is MSI TV VOX 8609 USB
2.0 which look quite different from my MSI Vox II USB.

Since there is already support for MSI VOX USB 2.0. I was hoping that
it will be a quick win to get Vox II supported.

Hopefully someone will be able to develop a patch to make it work. I
am prepared to provide assistant in whatever way I can.

I am probably going to dismantle the stick and post some pictures and
information.

regards,
 Hock.

On Tue, Feb 23, 2010 at 4:19 PM, Carlos Jenkins
<carlos.jenkins.perez@gmail.com> wrote:
> Hi, the symbol problem could get solved by restarting the system.
>
> On the other hand check this thread:
>
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/15991/
>
> Actually, the MSI Vox USB II device isn't working with the current tree.
>
> Cheers
>
