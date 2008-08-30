Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sat, 30 Aug 2008 17:08:45 +0200
From: Artem Makhutov <artem@makhutov.org>
To: Steven Toth <stoth@linuxtv.org>
Message-ID: <20080830150844.GQ7830@moelleritberatung.de>
References: <48B8400A.9030409@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <48B8400A.9030409@linuxtv.org>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

Hi,

On Fri, Aug 29, 2008 at 02:29:30PM -0400, Steven Toth wrote:
> Regarding the multiproto situation:
> 
> A number of developers, maintainers and users are unhappy with the
> multiproto situation, actually they've been unhappy for a considerable
> amount of time. The linuxtv developer community (to some degree) is seen
> as a joke and a bunch in-fighting people. Multiproto is a great
> demonstration of this. [1] The multiproto project has gone too far, for
> too long and no longer has any credibility in the eyes of many people.

Can you please explain me what you do not like in multiproto?

I can only see the two issues right now:

1. Binary incompatibility

As the DVB-API was not developed to work with advanced modulations like
DVB-S2 an API change is a must. As soon multiproto is in kernel the
distros and application maintainer will patch their applications to work
with multiproto.

2. Multiproto is not in kernel

Manu Abraham has just announced that multiproto can be merged:
http://www.linuxtv.org/pipermail/linux-dvb/2008-August/028351.html

I am using multiproto for some time now, and it works great.
It would be a waste of resources if you start a new project instead of
supporting multiproto.

Multiproto is ready, and can be merged in kernel NOW!
What we all want is support for new standards like DVB-S2.
Multiproto has accieved this. So why not using it?

Regards, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
