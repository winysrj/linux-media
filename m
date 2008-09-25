Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1KioOW-0001Fr-Ou
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 12:48:25 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Thu, 25 Sep 2008 12:48:20 +0200
References: <48DB3388.2030303@verbraak.org>
In-Reply-To: <48DB3388.2030303@verbraak.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809251248.20557.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] [RFC] Let the future decide between the two.
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

On Thursday 25 September 2008 08:45:28 Michel Verbraak wrote:
> I have been following the story about the discussion of the future of
> the DVB API for the last two years and after seen all the discussion
> I would like to propose the following:
>
> - Keep the two different DVB API sets next to one another. Both
> having a space on Linuxtv.org to explain their knowledge and how to
> use them. - Each with their own respective maintainers to get stuff
> into the kernel. I mean V4L had two versions.
> - Let driver developers decide which API they will follow. Or even
> develop for both.
> - Let application developers decide which API they will support.
> - Let distribution packagers decide which API they will have
> activated by default in their distribution.
> - Let the end users decide which one will be used most. (Probably
> they will decide on: Is my hardware supported or not).
> - If democracy is that strong one of them will win or maybey the two
> will get merged and we, the end users, get best of both worlds.
>
> As the subject says: This is a Request For Comment.

This is complete nonsense, distrobution packagers shouldn't decide which 
API should be used, the API and all drivers should be in the kernel. 
Having two tree is at best fragmentation and at worst a whole lot of 
duplicated work.
That should a user do if he has two devices which are only supported by 
one of the trees? That's bad luck?
Users can't decide because they are either forced by hardware or the 
application to use a tree. The only way to avoid this duplicated work. 

This is a stupid compromise proposal appeal both parties. A decision was 
made S2API is already merged we should just with it.

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
