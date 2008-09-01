Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+5d1aee805689a037d2dc+1835+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KaG22-0002I0-9V
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 22:29:50 +0200
Date: Mon, 1 Sep 2008 17:28:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jelle De Loecker <skerit@kipdola.com>
Message-ID: <20080901172843.49387677@mchehab.chehab.org>
In-Reply-To: <48BC253A.7050409@kipdola.com>
References: <200809010005.28716.liplianin@tut.by>
	<48BB0FE7.2010109@linuxtv.org>
	<a3ef07920809010938h22f71abfgb633ba9f06c2d41e@mail.gmail.com>
	<48BC253A.7050409@kipdola.com>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>, lucian orasanu <o_lucian@yahoo.com>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

Hi all,

Thanks for your feedback.

All of us are waiting for a long time for support for the new DTV standards.

The idea is not to postpone it, but to be sure that the API changes will be
flexible enough. Once an API change goes to kernel, It may take a large amount
of time for it to be removed. So extra care is taken on patches adding a
new kernel to userspace API.

I dunno if you are aware of how kernel development cycles are. 

There is a short period of 2 weeks for merging API changes and driver
improvements. This starts when a new kernel is released. After that 2 weeks
period, a bug fix period starts. We are currently under bug fix period for
kernel 2.6.27, at release candidate 5 (-rc5).

So, the minimum Kernel release that we may expect to add support for other
protocols is 2.6.28.

In general, a kernel bug fix cycle goes up to -rc8 or -rc9, being one rc
release by week. So, 2.6.27 kernel is likely to be released sometime after the
end of Plumbers conf. 

So, there's no gain of merging the API changes and the corresponding DVB-S2
drivers now.

Since several active Linuxtv maintainers will be at the conf for the Video
Input Infrastructure Miniconf, this will give us a perfect opportunity for
working together, carefully examining the technical details of both proposals,
and finish whatever is needed for the addition of API changes as soon as
possible and submit feedbacks to the ML.

So, it is very likely that we'll add support for those protocols for 2.6.28
inclusion.

Thanks,
Mauro.


On Mon, 01 Sep 2008 19:24:10 +0200
Jelle De Loecker <skerit@kipdola.com> wrote:

> You said everything that needed to be said, I agree with you 100 %
> 
> I vote for the merging of multiproto.


> 
> /Met vriendelijke groeten,/
> 
> *Jelle De Loecker*
> Kipdola Studios - Tomberg
> 
> 
> VDR User schreef:
> > After some consideration, I can not ack this new api proposal.  I
> > believe a lot of the support for it is based in people not knowing the
> > current state of multiproto and thinking this might be the only path
> > to new needed drivers.  It hasn't helped that there has been some
> > misinformation spread such as the binary compatibility and so on.
> > There is a current pull request for multiproto right now and if done,
> > drivers could start being developed right now.  In the end that's what
> > matters to users, especially those of us who've been patiently waiting
> > several months or even years.
> >
> > To my knowledge the multiproto api is very robust and can be easily
> > updated to accommodate new modulations, etc. From a technical
> > standpoint, I can't justify disregarding all the work thats been done
> > on multiproto, especially when it's finally ready to go.  In Mauro's
> > own response to the pull request, he admits the multiproto code is
> > complete.  Unless someone can provide legitimate reasons why we should
> > wait for yet another api to be written when multiproto is (finally)
> > ready to be pulled now, I'm afraid I can't support the idea.
> >
> > People have been waiting to move forward with a new api for a long
> > time and it seems we can with multiproto right now, today.  I don't
> > agree that makes a very strong case of too little, too late.  Whether
> > it's openly admitted or not, I think we're mostly all aware that there
> > is some personal politics involved in this as well, which is
> > unfortunate.  Hopefully people will be mature enough to put that aside
> > and do what's best for us, the linux dvb user base, as a whole.  After
> > learning that multiproto is ready and there's no technical reason
> > against it, I wonder how many people still choose to wait for another
> > api to be written..?
> >
> > Best regards guys!
> >   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
