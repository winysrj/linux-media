Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KZTmM-0005mr-Lb
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 18:58:28 +0200
Received: by py-out-1112.google.com with SMTP id a29so798812pyi.0
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 09:58:22 -0700 (PDT)
Message-ID: <1a297b360808300958k6bcd7e90q43e0e1e951eca8cc@mail.gmail.com>
Date: Sat, 30 Aug 2008 20:58:22 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48B963D1.3060908@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B8400A.9030409@linuxtv.org>
	<20080830150844.GQ7830@moelleritberatung.de>
	<48B963D1.3060908@linuxtv.org>
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

On Sat, Aug 30, 2008 at 7:14 PM, Steven Toth <stoth@linuxtv.org> wrote:
> Artem Makhutov wrote:
>> Hi,
>>
>> On Fri, Aug 29, 2008 at 02:29:30PM -0400, Steven Toth wrote:
>>> Regarding the multiproto situation:
>>>

>>
>> Can you please explain me what you do not like in multiproto?
>
>
> 1. Where is the support for ISDB-T/ATSC-MH/CMMB/DVB-H/DBM-T/H and other
> modulation types. If we're going to make a massive kernel change then
> why aren't we accommodating these new modulation types?

Adding a new modulation is just as good as adding in a new definition,
nothing more than that.

> If we don't
> added now then we'll have the rev the kernel ABI again in 2 months....

There is more than enough space in the enumeration for anything to be added.
Just adding more definitions without supported hardware is purely pointless.

> that isn't a forward looking future proof API.

The future doesn't lie in terms of some just basic modulation definitions alone.

> 2. It's too big, too risky, too late. It doesn't add enough new fatures
> to the kernel to justify the massive code change.

In fact in legacy mode, it is just as large as the existing API. In non-legacy
mode it is even still lighter. It's quite absurd to state that it is too big.

Also you need custom algorithm support for many of the newer demodulators
(Eg: stb0899 and others) which the existing API doesn't support. Well this
is also supported by the multiproto tree.


Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
