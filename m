Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33271 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbZJYSXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2009 14:23:46 -0400
Message-ID: <4AE497B5.8050801@iki.fi>
Date: Sun, 25 Oct 2009 20:23:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx DVB modeswitching change: call for testers
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
In-Reply-To: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/2009 06:52 AM, Devin Heitmueller wrote:
> Hello all,
>
> I have setup a tree that removes the mode switching code when
> starting/stopping streaming.  If you have one of the em28xx dvb
> devices mentioned in the previous thread and volunteered to test,
> please try out the following tree:
>
> http://kernellabs.com/hg/~dheitmueller/em28xx-modeswitch
>
> In particular, this should work for those of you who reported problems
> with zl10353 based devices like the Pinnacle 320e (or Dazzle) and were
> using that one line change I sent this week.  It should also work with
> Antti's Reddo board without needing his patch to move the demod reset
> into the tuner_gpio.
>
> This also brings us one more step forward to setting up the locking
> properly so that applications cannot simultaneously open the analog
> and dvb side of the device.

Reddo DVB-C USB Box works fine with this patch. But whats the status of 
this patch, when this is going to Kernel? Reddo is added to the 2.6.32 
and due to that I need this go 2.6.32 as bug fix. If this is not going 
to happen I should pull request my fix:
http://linuxtv.org/hg/~anttip/reddo-dvb-c/rev/38f946af568f

And other issue raised as well. QAM256 channels are mosaic. I suspect 
there is some USB speed problems in Empia em28xx driver since demod UNC 
and BER counters are clean. It is almost 50 Mbit/sec stream... Any idea? 
I tested modprobe em28xx alt=N without success...

regards
Antti
-- 
http://palosaari.fi/
