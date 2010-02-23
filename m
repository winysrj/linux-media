Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f204.google.com ([209.85.210.204]:61946 "EHLO
	mail-yx0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0BWMnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 07:43:35 -0500
Received: by yxe42 with SMTP id 42so265461yxe.4
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 04:43:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6e8e83e21002230029y11054c56w5c942f8f2401a9ae@mail.gmail.com>
References: <6e8e83e21002222329n30941317v2c8abda1866d6a98@mail.gmail.com>
	 <f535cc5a1002230019u214f48e8n165ebcb54a0be198@mail.gmail.com>
	 <6e8e83e21002230029y11054c56w5c942f8f2401a9ae@mail.gmail.com>
Date: Tue, 23 Feb 2010 20:43:34 +0800
Message-ID: <6e8e83e21002230443x196cde1aj557180079a1676cc@mail.gmail.com>
Subject: Re: modprobe em28xx failed for MSI Vox II USB
From: Bee Hock Goh <beehock@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just open up the USB stick and discovered that the video chip is
Trident TM5600 and tuner is Xceive XC2028.

Any help?

On Tue, Feb 23, 2010 at 4:29 PM, Bee Hock Goh <beehock@gmail.com> wrote:
> Carlos,
>
> Thanks for the reply. Actually your usb stick is MSI TV VOX 8609 USB
> 2.0 which look quite different from my MSI Vox II USB.
>
> Since there is already support for MSI VOX USB 2.0. I was hoping that
> it will be a quick win to get Vox II supported.
>
> Hopefully someone will be able to develop a patch to make it work. I
> am prepared to provide assistant in whatever way I can.
>
> I am probably going to dismantle the stick and post some pictures and
> information.
>
> regards,
>  Hock.
>
> On Tue, Feb 23, 2010 at 4:19 PM, Carlos Jenkins
> <carlos.jenkins.perez@gmail.com> wrote:
>> Hi, the symbol problem could get solved by restarting the system.
>>
>> On the other hand check this thread:
>>
>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/15991/
>>
>> Actually, the MSI Vox USB II device isn't working with the current tree.
>>
>> Cheers
>>
>
