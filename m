Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KZTtV-0006ra-C3
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 19:05:51 +0200
Received: by py-out-1112.google.com with SMTP id a29so799499pyi.0
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 10:05:45 -0700 (PDT)
Message-ID: <1a297b360808301005s1040d2b0l676ed80fce0947f7@mail.gmail.com>
Date: Sat, 30 Aug 2008 21:05:45 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Artem Makhutov" <artem@makhutov.org>
In-Reply-To: <20080830150844.GQ7830@moelleritberatung.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B8400A.9030409@linuxtv.org>
	<20080830150844.GQ7830@moelleritberatung.de>
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

On Sat, Aug 30, 2008 at 7:08 PM, Artem Makhutov <artem@makhutov.org> wrote:
> Hi,
>
> On Fri, Aug 29, 2008 at 02:29:30PM -0400, Steven Toth wrote:
>> Regarding the multiproto situation:
>>
>> A number of developers, maintainers and users are unhappy with the
>> multiproto situation, actually they've been unhappy for a considerable
>> amount of time. The linuxtv developer community (to some degree) is seen
>> as a joke and a bunch in-fighting people. Multiproto is a great
>> demonstration of this. [1] The multiproto project has gone too far, for
>> too long and no longer has any credibility in the eyes of many people.
>
> Can you please explain me what you do not like in multiproto?
>
> I can only see the two issues right now:
>
> 1. Binary incompatibility
>
> As the DVB-API was not developed to work with advanced modulations like
> DVB-S2 an API change is a must. As soon multiproto is in kernel the
> distros and application maintainer will patch their applications to work
> with multiproto.

Let me clear this up. There isn't any binary incompatibility. If you
need the newer
modulations/delivery systems, then you need to recompile the application for the
newer systems. Binary compatibilty exists completely with the old API.
Even if you
add in newer delivery systems/modulations later (with the API update),
as the size
of the data structures do not change, there doesn't occur any binary
incompatibility

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
