Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1KaBp8-0002TO-Vc
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 18:00:16 +0200
Received: by yx-out-2324.google.com with SMTP id 8so889905yxg.41
	for <linux-dvb@linuxtv.org>; Mon, 01 Sep 2008 09:00:10 -0700 (PDT)
Message-ID: <a3ef07920809010900l5f4bde4buaac6bcf38e9c034e@mail.gmail.com>
Date: Mon, 1 Sep 2008 09:00:10 -0700
From: "VDR User" <user.vdr@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <20080901120601.044ddc30@mchehab.chehab.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B9360D.7030303@gmail.com>
	<20080901120601.044ddc30@mchehab.chehab.org>
Subject: Re: [linux-dvb] Merge multiproto tree
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

On Mon, Sep 1, 2008 at 8:06 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> I'm aware that your solution seems to be more code-complete than Steven's
> proposal.
>
> But the recent activity on the mailing list regarding his idea (and its,
> so far, positive feedback) and the fact that I was anyway planning to
> have a discussion about the future of the DVB-API at the Linux Plumbers
> Conference 2008 are supporting me in my idea of post-poning such a pull to
> a point in time shortly after this event.

I understand peoples frustration in waiting for multiproto since I'm
one of them as well.  However, I believe the support for Steven's
proposal is largely because people aren't aware that multiproto is now
in a ready-state and has a pull request pending.  Over the last
several months I've seen many question when/if multiproto will be
done, or if it is dead...  I think we all agree that it has taken
quite some time for multiproto to get to a point where it's ready but
that time has come.

Multiproto -can- be pulled in right now, and if that happened, drivers
could be written immediately, finally providing users with what
they've needed for so long.  In my opinion it makes no sense to throw
out a robust api that is ready right now just because of frustration
and past personal grudges (whether anyone will openly admit to this or
not, it -is- a part of this).  The questions for consideration -should
be-... Is the code ready?  Can it handle future specs?  Is it missing
anything that should be included?  If the code is ready and is robust,
then the final question is what benefit is there in making people wait
yet longer for another api to be written?  Will this new api proposal
offer anything that multiproto doesn't already?

It seems we can finally move forward and now instead of incomplete
code stopping it, politics are.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
