Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server30.ukservers.net ([217.10.138.207])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stephen@rowles.org.uk>) id 1KbDJq-00049B-NN
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 13:48:13 +0200
Received: from miner.localdomain (unknown [78.146.23.243])
	by server30.ukservers.net (Postfix smtp) with ESMTP id D78C659C3B9
	for <linux-dvb@linuxtv.org>; Thu,  4 Sep 2008 12:48:01 +0100 (BST)
Received: from manicminer.homeip.net (miner [127.0.0.1])
	by miner.localdomain (Postfix) with ESMTP id 421E9181F5
	for <linux-dvb@linuxtv.org>; Thu,  4 Sep 2008 12:06:03 +0100 (BST)
Message-ID: <37990.81.144.130.125.1220526363.squirrel@manicminer.homeip.net>
In-Reply-To: <48BFBE68.7070707@beardandsandals.co.uk>
References: <48BF6A09.3020205@linuxtv.org>
	<48BFBE68.7070707@beardandsandals.co.uk>
Date: Thu, 4 Sep 2008 12:06:03 +0100 (BST)
From: "Stephen Rowles" <stephen@rowles.org.uk>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] S2API - First release
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

>> Steven Toth wrote:
>> A tuning demo app? What? Obviously, tuning older modulation types via
>> the new API isn't a requirements, but it's a useful validation exercise
>> for the new S2API.
>>
>> Steven
>
> Your statement about tuning older modulation types not being a
> requirement worries me. I would have thought it was an important
> requirement from an application perspective to be able to tune old and
> new modulation types through one api. The services I use (BSkyB and
> Freesat) are mostly DVB-S with very little if any S2. But I would like
> to be able to tune them via my (not so) new S2 card. Maybe I have
> misinterpreted what you meant.

I imagine that there isn't really any need to use the S2 API to tune older
modulation types, because you just use the existing API if you want the
old style tuning.

However I would agree that if the new API supports both old and new style
tuning, then that is nicer for anyone writing a new app, as they only have
to code for the S2API, and get support for all tuning styles. Unless I too
am not understanding :)


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
