Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.18]:22779 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZIJHJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 03:09:21 -0400
Message-ID: <4AA8A61F.8060707@gmail.com>
Date: Thu, 10 Sep 2009 09:09:19 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: David Whyte <david.whyte@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: saa7134 doesn't work after warm-reboot
References: <5df807700909082037n3d5ed809id2966632ce5e8a97@mail.gmail.com> <5df807700909092043u6afec694i38633ea5e73599fc@mail.gmail.com>
In-Reply-To: <5df807700909092043u6afec694i38633ea5e73599fc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've seen computer act strangely after such short power outage ( 
especially when that outage take a few ms ). Usually, the culprit is a 
low quality power supply, and i solve it by using a better quality one 
plus a surge protector (when i can't convice to buy a small UPS, at 
least :) ).

Beyond that suggestion i can't help you.

David Whyte a écrit :
> Further info, the power outage was for about 10 seconds in the latest
> incident.  Also, there is no need to unplug the PC power from the wall
> and press the power button etc to recover, you just need to leave the
> machine powered down for a short while.
>
> Sounds a lot like the issues I have read about where the firmware
> remains in the tuner card but is corrupt or something.  The only way
> is to clear the firmware and re-upload it, generally by powering down
> for sometime but I am hoping that you can do this by unloading then
> loading the modules.
>
> Is this possible?  Anyone know which modules in this instance?
>
> Regards,
> Whytey
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   



