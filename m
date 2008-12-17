Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web23206.mail.ird.yahoo.com ([217.146.189.61])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1LD5a3-0002Cv-F4
	for linux-dvb@linuxtv.org; Thu, 18 Dec 2008 00:13:28 +0100
Date: Wed, 17 Dec 2008 23:11:52 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1229023292.21398.0@manu-laptop>
MIME-Version: 1.0
Message-ID: <752414.24014.qm@web23206.mail.ird.yahoo.com>
Subject: Re: [linux-dvb] TT 3200: S2 transponder kind of locks with
	multiproto but not at all with S2 API
Reply-To: newspaperman_germany@yahoo.com
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

Hi Emmanuel,

this is the driver bug TT 3200 has, it has been discussed several times here, but noone knows solution.

kind regards


Newsy


--- Emmanuel ALLAUD <eallaud@yahoo.fr> schrieb am Do, 11.12.2008:

> Von: Emmanuel ALLAUD <eallaud@yahoo.fr>
> Betreff: [linux-dvb] TT 3200: S2 transponder kind of locks with multiproto but not at all with S2 API
> An: "Linux DVB Mailing List" <linux-dvb@linuxtv.org>
> Datum: Donnerstag, 11. Dezember 2008, 20:21
> Hi all,
> OK what the subject does not say: I want to tune to a
> DVB-S2 
> transponder on intelsat-903 (~34 W). FEC is said to be 5/6.
> OK so with a rather oldy multiproto driver I am getting
> kind of a lock 
> "DVB-S2 demod lock" (see the dmesg log) using
> simpledvbtune but it does 
> not seem to lock properly though as I dont get the viterbi
> lock and 
> everything.
> With S2API rather recent: nothing, no demod lock.
> 
> BTW using szap2 with multiproto driver gives me no demod
> lock either!?
> 
> Anyway if anyone can make some sense out of this or gives
> me some more 
> things to test out I'd be glad to try (yes I desperatly
> want to see 
> those HD channels ;-).
> Thx
> Bye
> Manu
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
