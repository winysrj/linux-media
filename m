Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1Jli0A-0007uJ-IS
	for linux-dvb@linuxtv.org; Tue, 15 Apr 2008 12:03:00 +0200
Message-ID: <48047D4E.8030603@iinet.net.au>
Date: Tue, 15 Apr 2008 18:02:54 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: sonofzev@iinet.net.au
References: <37824.1208252766@iinet.net.au>
In-Reply-To: <37824.1208252766@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico Fusion HDTV DVB-T dual express - willing to
 help	test e.t.c...
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

sonofzev@iinet.net.au wrote:
> Hi Folks
>
> I have mistakenly bought a Fusion HDTV DVB-T dual express (cx23885) as 
> a result of misreading some other posts and sites. I was under the 
> impression that it would work either from the current kernel source or 
> using Chris Pascoe's modules.  Unfortunately I didn't realise that the 
> American and Euro/Australian version were different.
>
> The kernel modules and those from the mercurial tree seems to get 
> everything going, but when I try to tune it, it seems to only give 
> "ATSC" tuning options. (This seems ridiculous as it is the 
> "Europe/Australia" model). I believe it must be recognising the card 
> as the American model (confirmed on the PC Board that it is the 
> Aus/Euro model). There are no error messages e.t.c.. it just can't 
> find a signal and only gives ATSC tuning options.
>
> Chris had offered to take a look at what was going on in my system but 
> hasn't responded to any mails for a few weeks now and I can't see any 
> evidence of him doing anything, so I am assuming he is too busy for 
> the moment to take a look.
>
> I bought this as a second and third tuner for my mythtv/gaming system 
> . The system already has a Fusion Lite card in it which is working 
> very well.  The importance of this was highlighted when I missed the 
> Henry Rollins interview on Rove so my gf could watch Grey's Anatomy 
> (puke!!!).
>
> If there are any local developers (Melbourne, Australia or even 
> elsewhere in Australia)  then I would be happy to trade it with a 
> confirmed working dual tuner card on a temporary basis to enable the 
> driver to be completed/ amended to cope with the Australian/European 
> version of the card.
>
> Otherwise for any developers not in Australia,I can setup a login for 
> you (ssh only, no remote X or anything). Just contact me via aklinbail 
> at gmail.  The PC it sits on is our one and only TV tuner (our analog 
> signal is crap) so there are some limitations as to the times you can 
> login to the box and also with regards to keeping the current kernel 
> build in place so we can use it on our return home from work in the 
> evening.
>
> cheers
>
>
> Allan
>
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
Hi Allan,
Have you tried Chris's test repo at:

http://linuxtv.org/hg/~pascoe/xc-test/


Regards,
Tim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
