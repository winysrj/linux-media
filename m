Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37322 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab3DWNcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 09:32:54 -0400
Received: by mail-qa0-f53.google.com with SMTP id p6so157436qad.5
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 06:32:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOS+5GGVt7Zsr1jJz=kC=98meQ3D+LYnNwoWDg1PWbwCaij2QA@mail.gmail.com>
References: <CAOS+5GGVt7Zsr1jJz=kC=98meQ3D+LYnNwoWDg1PWbwCaij2QA@mail.gmail.com>
Date: Tue, 23 Apr 2013 09:32:53 -0400
Message-ID: <CAGoCfizY7QQNFbwY=32fieRTtSzUm8enZc=FdpTYgpggHnJHAg@mail.gmail.com>
Subject: Re: Elgato DTT Deluxe V2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Another Sillyname <anothersname@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 23, 2013 at 8:13 AM, Another Sillyname
<anothersname@googlemail.com> wrote:
> I recently picked up one of these very cheap and am trying to load it into 'nix.
>
> According to this
>
> http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_DTT_deluxe_v2
>
> It should be recognised and load, and indeed when plugged in dmesg
> correctly reports it being detected and lsusb sees the device and the
> correctly reports the device ID.
>
> However there's no DVB section loading and I'm not sure why.
>
> I've copied the two .hex files to firmware and dmesg is not reporting
> any other outstanding requirements, however it's just not
> partying........
>
> Installed into a windows machine the drivers load and it reports OK
> (it's not tuning but I'm pretty sure that's a location issue at the
> moment).
>
> any ideas anyone?

The driver is still in the staging tree, and isn't compiled into the
kernel by default.  You'll have to either recompile your kernel to
include the "AS102" driver, or build the "media_build" tree.

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
