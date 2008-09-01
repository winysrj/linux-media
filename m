Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Mon, 1 Sep 2008 18:14:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcel Siegert <mws@linuxtv.org>
Message-ID: <20080901181450.4329ebc5@mchehab.chehab.org>
In-Reply-To: <48BC16E3.20500@linuxtv.org>
References: <48B9360D.7030303@gmail.com>
	<20080901120601.044ddc30@mchehab.chehab.org>
	<48BC16E3.20500@linuxtv.org>
Mime-Version: 1.0
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
	Manu Abraham <abraham.manu@gmail.com>
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

Hi Marcel,

On Mon, 01 Sep 2008 18:22:59 +0200
Marcel Siegert <mws@linuxtv.org> wrote:

> hello mauro,
> 
> Mauro Carvalho Chehab schrieb:
> > Hello, Manu,
> > 
> > On Sat, 30 Aug 2008, Manu Abraham wrote:
> > 
> >>  Hello Mauro,
> >>
> >>  Please pull from http://jusst.de/hg/multiproto_api_merge/
> >>  to merge the following Changesets from the multiproto tree.
> > 
> > The need for supporting newer DTV protocols increases day by day, since when
> > the first multiproto proposal started to be discussed, about two years ago.
> > 
> > At the end of the last year, Steven send one email to the ML with a different 
> > API proposal. Yet, people decided to wait for your work to be done. People then 
> > pinged you, from time to time, asking about the completion of multiproto. All 
> > the times, your answer were that multiproto were not ready yet for production.
> > 
> how is the actual state of his proposal? 

Steven can explain the details. Basically: it works, it is simple to
understand and to work with, and it seems to be flexible enough to support all
current needs and seems to be flexible enough to support future protocols. It is
currently under review based on community feedback.

I didn't have time yet to do carefully inspect the latest version of the
multiproto. I suspect that nobody did it yet, since I didn't see any technical
analysis of the current proposal.

I'll carefully review multiproto proposal during my trip, and compare it
with the Stoth's proposal.

> > I'm aware that your solution seems to be more code-complete than Steven's 
> > proposal.
> 
> > 
> > But the recent activity on the mailing list regarding his idea (and its, 
> > so far, positive feedback) and the fact that I was anyway planning to 
> > have a discussion about the future of the DVB-API at the Linux Plumbers 
> > Conference 2008 are supporting me in my idea of post-poning such a pull to 
> > a point in time shortly after this event.
> with whom? the linuxtv developers or with an attending audience?

We'll have some sort of panel or speech for the attending audience of the Video input
infrastructure miniconf. The API analysis will happen with the Linuxtv
developers that will be there.

> i havent been on the list and that active since the "nearly two years war" begun,
> thus i am not the one to ack or nack in this pull request.
> 
> what i did in the past was just watching what was happening and what was taking
> progress - even if it is slow. 
> 
> users on the linuxtv list started to ask over and over again, when multiproto is
> going to be merged. vdr started to support it in a kind of experiment.
> 
> due to the lack of spare time and devices :) i do not actually know how productive 
> the vdr multiproto implementation is, but we should not start the whole discussions again.
> 
> if we do not merge multiproto now, we will never do it, i am afraid. 
> 
> for the future of this project it is more than neccessary to get some progress.
> 
> if there are no serious objections to multiproto, mauro, please pull/merge it 
> within the next few days. to wait until the end of september is time spending without
> any sense.

As I've already explained, merging today or after Plumbers won't make any
practical difference. The upstream merge will only happen after 2.6.27 being
released, due to the next kernel window for merging patches. This is a major
change at API and claims for a carefully analysis.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
