Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KiIfX-0003Tb-F8
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 02:55:52 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1943011fga.25
	for <linux-dvb@linuxtv.org>; Tue, 23 Sep 2008 17:55:48 -0700 (PDT)
Message-ID: <d9def9db0809231755g4f97bdc8r846e40476ca2cd99@mail.gmail.com>
Date: Wed, 24 Sep 2008 02:55:48 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Janne Grunau" <janne-dvb@grunau.be>
In-Reply-To: <200809240236.15144.janne-dvb@grunau.be>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<a3ef07920809231506h722c9fd4h1e3b8c3e40ca32cb@mail.gmail.com>
	<200809240236.15144.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, Sep 24, 2008 at 2:36 AM, Janne Grunau <janne-dvb@grunau.be> wrote:
> On Wednesday 24 September 2008 00:06:59 VDR User wrote:
>> On Tue, Sep 23, 2008 at 2:16 PM, Mauro Carvalho Chehab
>>
>> <mchehab@infradead.org> wrote:
>> > The DVB BOF had the presence of the following LinuxTV members:
>> >
>> >        Douglas Schilling Landgraf
>> >        Hans Verkuil
>> >        Mauro Carvalho Chehab
>> >        Michael Krufky
>> >        Patrick Boettcher
>> >        Steven Toth
>> >        Thierry Merle
>> >        Manjunath Hadlii
>>
>> At least half of that list already pledged their support for S2API
>> and based on past observations, I seriously doubt the meeting was
>> unbiased and a decision made based on strictly technical aspects.
>
> So you doubt anyone who previously stated his opinion on multiproto or
> S2API is unable to make a decision on technical merrits? Since most
> linuxtv devs already gave their opinion on the API proposal nobody is
> able to make a decision.
>
>> I also believe the panel should consist of people intimately familiar
>> with DVB, not half people who aren't and the other half people who've
>> already made up their mind.  Call me crazy but I don't see how a
>> legitimate discussion can take place under those conditions.
>
> Are you going to sponser and organize a meeting of all linuxtv DVB
> developers?
> I agree that it would have been nice if more developers and especially
> Manu would have been at the DVB BOF. But more than 2/3 (849/1245) of
> the commits to drivers/media/dvb in the last 1000 days were done by
> people present at the meeting. It's not completly unreasonable to treat
> a decision of that group as a decission of the linuxtv developers.
>

sorry to strong reply here, what commits? I respect people who wrote
code on their own
eg. Thierry Merle. But there are just alot commits from other people too.
This also takes my code into account which got taken from my repository.
My code seems to be good enough for adding other copyrights and
hijacking the maintainership (! - em28xx-alsa
which got copied including the existing bugs back then).

Just don't make it up to those commits. A widely public technical
discussion can be done on the ML and
this should be the way to solve that issue.

1. S2API adds another question who's going to port the multiproto drivers
2. who's going to test them, since they are already supported by eg. vdr
3. I know Manu is working on upcoming devices, telling him to use the
S2API would mean to reinvent the wheel I guess, so
how to avoid that best.

>> > The main arguments in favor of S2API over Multiproto are:
>> >
>> >        - Future proof =96 the proposal for S2API is more flexible,
>> > easily allowing the addition of newer features and new standard
>> > support;
>> >
>> >        - Simplicity =96 S2API patches are very simple, while
>> > Multiproto presented a very complex series of changes. Simpler
>> > approaches reduces the time for maintaining the source code;
>> >
>> >        - Capability of allowing improvements even on the existing
>> > standards, like allowing diversity control that starts to appear on
>> > newer DVB devices.
>>
>> My previous comment aside, I would like to ask for a more detailed
>> explanation that justifies these arguments,
>
> I support that, please be more verbose.
>

I don't mind about which solution gets used actually, but the
technical part of it should either be more verbose
and not only be a Hauppauge Lab solution for _their_ current products
only, the multiproto drivers have been available
before already so they should be wisely taken into account in order to
not drop them and telling those people who worked
on it redo it.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
