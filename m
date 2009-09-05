Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:65234 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZIEQYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Sep 2009 12:24:21 -0400
Received: by yxe5 with SMTP id 5so3767531yxe.33
        for <linux-media@vger.kernel.org>; Sat, 05 Sep 2009 09:24:24 -0700 (PDT)
Message-ID: <4AA290CF.5000806@gmail.com>
Date: Sun, 06 Sep 2009 02:24:47 +1000
From: Jed <jedi.theone@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: generic question
References: <4AA28EBB.5070401@gmail.com>
In-Reply-To: <4AA28EBB.5070401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Actually I just realised...

I think when the system reboots it will only load the modules it needs 
from /lib/modules/[kernel version]/kernel/drivers/media...
It won't load everything in that directory into the kernel/memory right?

So the only reason one might want to use "make menuconfig"; is to 
prevent irrelevant compiled modules ending up in...
/lib/modules/[kernel version]/kernel/drivers/media

Feel free to correct if this understanding is wrong.

Cheers

Jed wrote:
> I installed _all_ dvb-v4l modules after compiling latest source 
> because at the time I couldn't use "make menuconfig" (didn't have 
> ncurses installed)
> Is there a way I can retrospectively remove some compiled/installed 
> modules so that I'm only using the ones I need?
> I only need modules associated with: 
> http://www.linuxtv.org/wiki/index.php/Saa7162_devices#DNTV_PCI_Express_cards 
>
>
> Cheers,
> Jed
>

