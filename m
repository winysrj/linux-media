Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab0C3Sqb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 14:46:31 -0400
Message-ID: <4BB24701.6080702@redhat.com>
Date: Tue, 30 Mar 2010 15:46:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>, linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV HVR-900H
References: <20100329165838.GA3220@joro.homelinux.org> <20100328153759.GA2893@joro.homelinux.org> <20100328120729.GB6153@joro.homelinux.org> <20100328105145.GA2427@joro.homelinux.org> <27890244.1269777077513.JavaMail.ngmail@webmail18.arcor-online.net> <23371307.1269778330976.JavaMail.ngmail@webmail11.arcor-online.net> <2835345.1269794199129.JavaMail.ngmail@webmail15.arcor-online.net> <6043841.1269886000700.JavaMail.ngmail@webmail18.arcor-online.net> <20100330181306.GA2392@joro.homelinux.org>
In-Reply-To: <20100330181306.GA2392@joro.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

George Tellalov wrote:
> On Mon, Mar 29, 2010 at 08:06:40PM +0200, Stefan Ringel wrote:
>>  
>> Can you scan a cannel list? If yes, then have you the right audio and video setting in vlc? And if you use Kaffeine? The log looks ok, dvb signal has it, streams and feed is on. 
>>
> 
> For some reason I can't get the dvbscan tool and the vlc to work. However
> kaffeine works just fine - it performed the scan and played the channels, so I
> can confirm now that dvb works.
> 
> Now back to analog. Is there anything I can do to help debugging the oops?

The bug is somewhere in the code that fills the video buffers, at tm6000-video.
In order to fix, you'll likely need to have a separate machine, and use a 
serial cable for console, since you may eventually convert the bug into a
Panic again and, without the console, you'll loose the error dumps.

Alternatively, you may try to start your machine on text mode and use some program
to capture the traffic, like capture-example (on v4l-utils tree).

It should be noticed that older versions of the code worked without generating
panic or oops. So, maybe digging into tm6000-video history, you may be able to 
find a code that won't cause panic/oops. The problem with the old code is that sometimes
the code weren't able to produce an entire frame (lots of dropped/missed URB's).

It should also be noticed that videobuf-vmalloc suffered a few changes along the time.
So, if you backport a really old code, you'll likely need to re-apply some fixes on
the code, due to the videobuf changes.

-- 

Cheers,
Mauro
