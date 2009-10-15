Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp102.mail.ukl.yahoo.com ([77.238.184.34]:21233 "HELO
	smtp102.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758810AbZJOXkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 19:40:10 -0400
Message-ID: <4AD7B2AF.8000602@yahoo.it>
Date: Fri, 16 Oct 2009 01:39:27 +0200
From: SebaX75 <sebax75@yahoo.it>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx DVB modeswitching change: call for testers
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
In-Reply-To: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller ha scritto:
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
> 
> Thanks for your help,
> 
> Devin

Hi Devin,
excuse my late, but I've done some test.

The scanning now work correctly and without problem, all MUX was tuned 
and channel recognized.

With mplayer no problem, for a new channel I must stop the actual 
channel viewing and start a new one instance of mplayer.

I've a problem with kaffeine, and this problem before was not present 
(I've not tested with the previous temporary patch).
To reproduce the problem, is necessary a channel change, and the two 
channel must be on a different MUX: the first double click on new 
channel name display an "Impossible to tune", if I do a new double click 
the channel was opened. Is like the adapter was resetted, but not 
reinitialized on new frequency.
Logically the problem not appears if I stop the transmission between the 
channel change or if I change channel that are located on the same MUX.

I hope to have explained well the thing.

Thanks and bye,
Sebastian

