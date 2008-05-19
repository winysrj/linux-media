Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1Jy7gz-0002ov-0M
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 17:54:31 +0200
Message-ID: <4831A292.4070704@chaosmedia.org>
Date: Mon, 19 May 2008 17:53:54 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48310988.8080806@pilppa.org> <4831434A.7000502@chaosmedia.org>
	<48318B8C.7040900@pilppa.org>
In-Reply-To: <48318B8C.7040900@pilppa.org>
Subject: Re: [linux-dvb] Well working S2 cards?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


> Mika Laitio wrote:
> But nice to hear that all 3 of these cards have changes to work both 
> with S and S2.
As i said i haven't had any problems with my tt s2-3200 and multiproto 
driver.
I believe that "budget" cards like that one are easier to support 
because their design is basic.


> It would be interesting to find some dvb-t usb gadget for playing with 
> it and laptop while sitting on the city cafe.
some usb dvb-t adapters are supported but never tested that so i can't 
tell for sure.
i need to get a dvb-t device myself but it'll be a pci one..

> Yeah, the 780G chipset I have has something called UVD 2.0 integrated 
> to motherboard that should provide hardware acceleration for decoding 
> VC-1, H.264 (AVC), WMV, and MPEG-2 sources up to 1080p resolutions. 
> But I pet no-one has data available for getting the Linux 
> encoding/decoding libraries to support those features.
>
There's no GPU hardware acceleration currently on linux, as far as i 
known, besides xvmc for MPEG2 on nvidia chipsets if i'm correct..
So you'll have to rely only on your CPU for decoding h264 and that can 
be quite tricky with 1080i..

As Igor pointed out there's an existing project to bring coreavc support 
to 64 bit linux, but i couldn't get it to work so far and have no idea 
how stable it actually is..
Having something that "works" is very different from having something 
that works but will crash or freeze your app every few channel zap..
But again i'm not telling it's not working as i couldn't get it to work 
on my setup yet..

Good luck.

Marc


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
