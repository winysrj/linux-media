Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KjIxB-0002IS-Lg
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 21:26:14 +0200
Received: by fg-out-1718.google.com with SMTP id e21so740495fga.25
	for <linux-dvb@linuxtv.org>; Fri, 26 Sep 2008 12:26:10 -0700 (PDT)
Message-ID: <d9def9db0809261226r2134c56apcbb2b27552079d2c@mail.gmail.com>
Date: Fri, 26 Sep 2008 21:26:10 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1222454633.2675.11.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
References: <200809241922.16748@orion.escape-edv.de>
	<1222306125.3323.80.camel@pc10.localdom.local>
	<200809261714.58188@orion.escape-edv.de>
	<1222454633.2675.11.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org, v4l-dvb-maintainer@linuxtv.org, vdr@linuxtv.org
Subject: Re: [linux-dvb] [v4l-dvb-maintainer] [Wanted] dvb-ttpci maintainer
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

On Fri, Sep 26, 2008 at 8:43 PM, hermann pitton <hermann-pitton@arcor.de> wrote:
>
> Am Freitag, den 26.09.2008, 17:14 +0200 schrieb Oliver Endriss:
>> hermann pitton wrote:
>> > Except of course a majority of plumbers at the same place at the same
>> > time can create/propose some facts.
>>
>> IMO decisions must be made where the community is, i.e. on the mailing
>> list. Not at a conference, no matter whether it is at one end of the
>> world or on the dark side of the moon. ;-(
>>
>> To make it absolutely clear:
>> I did not leave _because_ S2API was selected.
>> I left because it was done _this_way_.
>>
>> Good for those, who are fine with these methods. I am not.
>
> What the others should have done previously?
>
> They could only wait.
>
> What should Mauro have done better?
>
> Say, after Manu's pull request suddenly appeared, thanks, I merge it now
> over night and forget about all efforts others did.
>
>> > If you attack people such hard as Manu did, also behind the visible
>> > lines sometimes, Marcel had a copy from me concerning Mauro and did say
>> > nothing, you must not wonder about people starting to defend themselves.
>>
>> I consider flame wars ridiculous. I did not participate, and I will not
>> participate in the future.
>>
>> I believe that I know very well what is going on. (During more than 30
>> years in software development I have seen all kinds of problems. I know
>> how people react and why things happen.)
>>
>> > For sure the dirt was not started from v4l people.
>> >
>> > Think it over.
>>
>> Unlikely. I made this decision after sleeping over it for a few days.
>> Now I feel much better.
>>
>> Oliver
>>
>
> You are the most trusted guy on linux-dvb for me.
>
> Markus should have accept your help instead giving Mauro an ultimatum to
> merge his stuff within the next 24 hours and we would have one problem
> less.
>

Hermann,

I really have to write that it was a good decision to stay away from
my code previously.
Not because I didn't follow some suggestions which seemed to be
ridiculous to me (and due
general lack of knowledge others and I had), it's because the code was
not manufacturer supported
at that time.
The supported code which redesigned alot parts of the old driver are
improved alot and those
changes were also influenced by business customers who back then
thought "we could use that work
since it states out it supports xyz". Those business customers did in
depth testing of their scenarios
and requirements and submitted valuable bugreports and or even patches
(eg VBI support, signal strength
improvements due wrong firmwares -or even wrong register settings,
mode switchover testing etc.)

I am not at all angry at anyone denying to merge the code around a
year ago since the whole situation
changed, overall the bad communication back then which definitely was
not driven by any community
rather than personalities just resulted in that overall bad
atmosphere. I think all that is far away now
and many things changed to a positive result for endusers in terms of
code quality now.

There are still some outstanding points on the list, in order to not
break other devices it requires alot
testing. It's being worked on I can write. Looking at the work which
has been done at Xceive even their
supplied code changed due the firmware upgrades and we supported them
in order to fix some smaller
bugs too.

Due the whole development I also have to write that I have alot
respect of what the Empia
windows developer is and was doing in order to support all those
possible device configurations it's a
very complicated task, and he's also on it fulltime for some good reason.

best regards,
Markus

> Put at least a sticker on such guys like Uwe/Derek and Manu should do it
> as well.
>
> I'm open for everything fair to find a solution.
>
> Hermann
>
>
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
