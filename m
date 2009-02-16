Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52993 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751022AbZBPRV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 12:21:58 -0500
Message-ID: <4999A0A8.2070500@gmx.de>
Date: Mon, 16 Feb 2009 18:21:44 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Jean-Louis Dupond <info@dupondje.be>
CC: linux-media@vger.kernel.org
Subject: Re: Bad sound on HVR1300 & cx88-alsa not loading anymore for HVR1300
References: <4998A55E.6020808@dupondje.be>
In-Reply-To: <4998A55E.6020808@dupondje.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello,
>
> I'm running Ubuntu 8.10, and 2.6.27-11-generic kernel. I also tried 
> compiling the newest modules from linuxtv.
>
> The first problem:
> The sound from my HVR1300 is really bad, it like a robotic sound, with 
> high tones in it!
>
> 2nd problem:
> cx88-alsa module is not loading automaticly when booting my system. 
> While my HVR1300 needs it !
>
> Regards,
> Jean-Louis Dupond
>
So that means you do have at least any sound, different as it is for me?
I guess you're not using the cx88_blackbird module, since you use the 
alsa device for sound?

Are you using PAL video norm on TV input and does your initialisation 
differ from mine, see some posts before yours?

-Winfried
