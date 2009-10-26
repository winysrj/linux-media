Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58076 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbZJZQCE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 12:02:04 -0400
Message-ID: <4AE5C7F9.6000502@iki.fi>
Date: Mon, 26 Oct 2009 18:02:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx DVB modeswitching change: call for testers
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>	 <4AE497B5.8050801@iki.fi> <829197380910260836o4b17a65ex8c46d1db8d6d3027@mail.gmail.com>
In-Reply-To: <829197380910260836o4b17a65ex8c46d1db8d6d3027@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve Devin,

On 10/26/2009 05:36 PM, Devin Heitmueller wrote:
> Hello Antti,
>
> Sorry, I'm a couple of days behind on email.
>
> On Sun, Oct 25, 2009 at 2:23 PM, Antti Palosaari<crope@iki.fi>  wrote:
>> Reddo DVB-C USB Box works fine with this patch. But whats the status of this
>> patch, when this is going to Kernel? Reddo is added to the 2.6.32 and due to
>> that I need this go 2.6.32 as bug fix. If this is not going to happen I
>> should pull request my fix:
>> http://linuxtv.org/hg/~anttip/reddo-dvb-c/rev/38f946af568f
>
> I've received some very mixed results in terms of testing of the patch
> (as you can see from the responses).  Even stranger, I received mixed
> responses from people with the same boards.  I haven't had a chance to
> debug *why* the people who raised problems still had an issue.  I
> continue to believe it's the "right fix" but I don't know why those
> people reported problems with it.

OK, I will wait then.

>> And other issue raised as well. QAM256 channels are mosaic. I suspect there
>> is some USB speed problems in Empia em28xx driver since demod UNC and BER
>> counters are clean. It is almost 50 Mbit/sec stream... Any idea? I tested
>> modprobe em28xx alt=N without success...
>
> What do you mean by "mosaic"?  Can you try using dvbstreamer and see
> what the overall throughput is?  That will tell us if we are not
> getting the whole stream.
>
> You cannot rely on the "alt=n" for DVB.  The max packet size is
> determined by an em28xx register.

I mean picture is bad, very much errors on stream. Look this thread for 
sample picture:
http://linuxtv.fi/viewtopic.php?t=3661&postdays=0&postorder=asc&start=15

I did some more tests yesterday after sending that mail. Problem seems 
to be that em28xx does not transfer bytes faster than ~46 Mbit/sec 
whilst stream is over 50 Mbit/sec. About 5 Mbit/sec is lost... I ensured 
that comparing towards Anysee E30C Plus DVB-C which has same demodulator 
(TDA10023). Anysee is just fine, Empia not. I looked stream sizes by 
using dvbtraffic.

Is there any way to speed up Empia to handle streams bigger than ~45 
Mbit/sec?

regards
Antti
-- 
http://palosaari.fi/
