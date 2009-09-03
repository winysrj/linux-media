Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp27.orange.fr ([80.12.242.95]:11908 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZICFkE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 01:40:04 -0400
Message-ID: <4A9F56B4.9000809@gmail.com>
Date: Thu, 03 Sep 2009 07:40:04 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: (EC168) PC Basic TNT USB Basic V5 ( France ) recognized but no
 channel tuning
References: <4A9EC8B3.10904@gmail.com> <4A9EEBB2.60709@iki.fi>	 <4A9EF92B.2000506@gmail.com> <1251933172.3253.14.camel@pc07.localdom.local>
In-Reply-To: <1251933172.3253.14.camel@pc07.localdom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton a écrit :
> Hi Morvan,
>
> HVR 1100 and HVR 1110 are totally different boards.
>
> How does GNU/Linux detect the board on your recent kernel?
>
> Sorry, I might be in delay reading previous messages.
>
> Even on the HVR 1110 we have unclear situations, concerning that some of
> them might have an additional LowNoiseAmplifier, which needs to be
> configured correctly, and others not.
>
> It might even be the case, that there are at least three different types
> of such LNAs recently, and we don't know how to detect them.
>
> All needing a different setup.
>
> Please copy/paste device related dmesg output.
>
> I still have not give up on it, that we might be able to identify those
> different devices in the future.
>
> Until somebody tells me better ...
>
> Cheers,
> Hermann
>
>
>   
it is a 1110 one ( triangular shaped ) but it may be a new design or 
something else. I don't have it here for the moment so i can't give 
exact info but i tried the "card=104" and "card=156" options ( no 
autodetection )  with no result ( analog TV and DVB  didn't work ).
 ( In the meantime, it's back in its box, waiting for a day where it 
will work with my mythbuntu box :) )



