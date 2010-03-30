Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:35735 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab0C3SNM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 14:13:12 -0400
Received: by ewy20 with SMTP id 20so1535400ewy.1
        for <linux-media@vger.kernel.org>; Tue, 30 Mar 2010 11:13:11 -0700 (PDT)
Date: Tue, 30 Mar 2010 21:13:06 +0300
From: George Tellalov <gtellalov@bigfoot.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV HVR-900H
Message-ID: <20100330181306.GA2392@joro.homelinux.org>
References: <20100329165838.GA3220@joro.homelinux.org>
 <20100328153759.GA2893@joro.homelinux.org>
 <20100328120729.GB6153@joro.homelinux.org>
 <20100328105145.GA2427@joro.homelinux.org>
 <27890244.1269777077513.JavaMail.ngmail@webmail18.arcor-online.net>
 <23371307.1269778330976.JavaMail.ngmail@webmail11.arcor-online.net>
 <2835345.1269794199129.JavaMail.ngmail@webmail15.arcor-online.net>
 <6043841.1269886000700.JavaMail.ngmail@webmail18.arcor-online.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6043841.1269886000700.JavaMail.ngmail@webmail18.arcor-online.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 29, 2010 at 08:06:40PM +0200, Stefan Ringel wrote:
>  
> Can you scan a cannel list? If yes, then have you the right audio and video setting in vlc? And if you use Kaffeine? The log looks ok, dvb signal has it, streams and feed is on. 
> 

For some reason I can't get the dvbscan tool and the vlc to work. However
kaffeine works just fine - it performed the scan and played the channels, so I
can confirm now that dvb works.

Now back to analog. Is there anything I can do to help debugging the oops?
