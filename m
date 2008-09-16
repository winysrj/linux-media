Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.pena.perez@gmail.com>) id 1KfXUD-0000u2-ON
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 12:08:49 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2609638rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 03:08:41 -0700 (PDT)
Message-ID: <28a25ce0809160308u79b67730u8a53d5db1d19f87e@mail.gmail.com>
Date: Tue, 16 Sep 2008 12:08:41 +0200
From: "=?ISO-8859-1?Q?Rom=E1n?=" <roman.pena.perez@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <28a25ce0809160307p50bf7126n1a486374857d5893@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <e32e0e5d0809151515y26eab250x697fea6768af93af@mail.gmail.com>
	<48CEF1CE.8080202@linuxtv.org>
	<28a25ce0809160307p50bf7126n1a486374857d5893@mail.gmail.com>
Subject: [linux-dvb] Fwd:  why opensource will fail
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

2008/9/16 Steven Toth <stoth@linuxtv.org>:
> Tim Lucas wrote:
>>     Message: 7
>>     Date: Sat, 13 Sep 2008 16:31:16 -0400
>>     From: Steven Toth <stoth@linuxtv.org <mailto:stoth@linuxtv.org>>
>>     Subject: Re: [linux-dvb] why opensource will fail
>>     To: Paul Chubb <paulc@singlespoon.org.au
>>     <mailto:paulc@singlespoon.org.au>>
>>     Cc: linux dvb <linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>>
>>     Message-ID: <48CC2314.4090800@linuxtv.org
>>     <mailto:48CC2314.4090800@linuxtv.org>>
>>     Content-Type: text/plain; charset=3DISO-8859-1; format=3Dflowed
>>
>>     Paul Chubb wrote:
>>      > Hi,
>>      >      now that I have your attention:-{)=3D
>>
>>     .... You've also had my attention in the past, if I recall I have you
>>     tips about not using cx_write, instead using cx_set/cx_clear.
>>
>>     Your latest patch still doesn't have those changes btw. ;)
>>
>>
>>      >
>>      > I believe that this community has a real problem. There appears t=
o be
>>      > little willingness to help and mentor newcomers. This will limit =
the
>>      > effectiveness of the community because it will hinder expansion of
>>      > people who are both willing and able to work on the code. Eventua=
lly
>>      > this issue  will lead to the community dying simply because you h=
ave
>>      > people leaving but few joining.
>>
>>     I disagree with everything you've just said, but that's just my opin=
ion.
>>
>>
>>      >
>>      > The card I was working on has been around for  a while now. There
>>     have
>>      > been three attempts so far to get it working with Linux. Two in t=
his
>>      > community and one against the mcentral.de <http://mcentral.de>
>>     tree. Both attempts in this
>>      > community have failed not because of a lack of willingness of the
>>     people
>>      > involved to do the hard yards but because of the inability of the
>>      > community to mentor and help newcomers.
>>
>>
>>     Did I not try to help you? The one piece of initial feedback I gave =
you,
>>     you ignored. (see my opening statement).
>>
>>     I'm always willing to help people, but they also have to demonstrate
>>     that they are applying themselves, doing basic research, asking spec=
ific
>>     questions ... rather than, here's my patch - and What's Wrong with i=
t.
>>
>>
>>      >
>>      > The third attempt by a Czech programmer succeeded, however it is
>>      > dependent on the mcentral.de <http://mcentral.de> tree and the
>>     author appears to have made no
>>      > attempt to get the patch into the tree. The original instructions=
 to
>>      > produce a driver set are in Czech. However instructions in
>>     english for
>>      > 2.6.22 are available - ubuntu gutsy. I will soon be putting up
>>      > instructions for 2.6.24 - hardy. They may even work  for later
>>     revisions
>>      > since the big issue was incompatible versioning.
>>      >
>>      > I understand from recent posts to this list that many in the
>>     community
>>      > are disturbed by the existence of mcentral.de
>>     <http://mcentral.de>. Well every person from
>>      > now on who wants to run the Leadtek Winfast DTV1800H will be
>>     using that
>>      > tree. Since the card is excellent value for what it is, there
>>     should be
>>      > lots of them. Not helping newcomers who are trying to add cards
>>     has led
>>      > and will lead to increased fragmentation.
>>
>>     So port the mcentral.de <http://mcentral.de> details into the
>>     kernel, I doubt they'll be
>>     significantly different.... we're talking about adding support for an
>>     existing card, it's not a lot of engineering work.
>>
>>
>>      >
>>      > And before you say or think that we are all volunteers here, I am=
 a
>>      > volunteer also. I have spent close to 3 weeks on this code and it=
 is
>>      > very close to working. The biggest difference between working cod=
e in
>>      > the mcentral.de <http://mcentral.de> tree and the patch I was
>>     working on is the firmware that
>>      > is used.
>>
>>     ... and your efforts are valuable.
>>
>>     Markus (mcentral.de <http://mcentral.de>) is paid to work on Linux,
>>     just to be clear.
>>
>>     Your last message on that thread said: "xc2028 2-0061: xc2028/3028
>>     firmware name not set!"
>>
>>     You could of asked a second time before taking the opportunity to ve=
nt,
>>     and taking the community to task.
>>
>>     Showing patience and perseverance is what most other newcomers
>>     demonstrate.
>>
>>
>>      >
>>      > Finally you might consider that if few developers are prepared to
>>     work
>>      > on the v4l-dvb tree, then much of the fun will disappear because
>>     those
>>      > few will have to do everything.
>>
>>     Whether we have 3 people or 30, it's never enough.
>>
>>     In my experience, people who join the list then vent all over it are
>>     rarely around long enough to make a difference. They often think they
>>     know more about the community than the community itself.
>>
>>     On the other hand, the people who join and ask well thought out
>>     questions, describe their failures and working assumptions, then
>>     demonstrate a willingness to learn attract a mentor very quickly.
>>
>>     ... just my opinion of course :)
>>
>>     If you want to make progress with the leadtek card then another look=
 at
>>     the feedback I gave you, then approach the group again with a more
>>     insightful email.
>>
>>     Maybe someone will help you then.
>>
>>     - Steve
>>
>>
>> I would like to respond to this because I have been sending messages to
>> the list asking for help, but after a couple initial suggestions, I have
>> been completely ignored.  I need to work with the cx23885 drivers with
>> analog support that Steve wrote, because they are the only ones around,
>> but how am I supposed to get them to work if the person who wrote them
>> will not help me.   I even reported progress, but I was still ignored.
>>  In fact, I saw other people get help with questions that were as silly
>> as mine, but for some reason I cannot get any help from Steve or anyone
>> else on the list.  I have said before that I am willing to do some of
>> the work, but there is a steep learning curve.
>>
>> If I have done something against the rules or to deserve this treatment,
>> I would appreciate someone letting me know instead of just ignoring me.
>>  Where else can I go for help?
>>
>> If anyone has any suggestions about what I can do, please see my latest
>> posts to the list about analog support for cx23885 cards.  Thank you.
>>
>>      --Tim
>
> Tim,
>
> Just to be clear, they're not my patches I just offered to merge them. :)
>
> The people who can help are busy working on other projects, that's just
> the way Linux development works. I tend to work on Hauppauge hardware
> projects first then anything else if I have time.
>
> Too many people come to the list and have their problems solved and give
> nothing in return. This is bad. They walk away feeling pretty happy but
> they don't stop behind to help 2 other people. If everyone I helped
> stopped to help 2 other people then the group would be a better place.
> Likewise for all of the other developers in this group.
>
> In the end, people stop helping each other because it's a non-stop tide
> of help requests, for little in return.
>
> I'm not suggesting that you do that, I'm suggest that's why the group is
> the way it is.
>
> Stick around, when people have enough time you'll get some attention.
>
> - Steve
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

I think the main problem is not having separate lists for development
and help/support. The development efforts suffer a lot from this. I
did experience that silence myself when working on adding support for
my device; at first, the linuxtv community seemed to ignore me, but
after a lot of patience and insistence, I got positive replays from
Antii and others. Then, I knew the problem was the high load of the
list (Apart from regular e-mail, I'm subscribed to about a dozen
lists, but 80% of my inbox is from linuxtv).

Anyway, IMHO there's no easy solution to this: for instance, a problem
regarding compilation on Ubuntu with the latest svn branch is hard to
classify as development or support or both. Maybe it'd be a better
idea to have a lot of lists for specific tasks: one for core/api
development, one for new devices and drivers, one for new channel
files, seamless patches and such, and one for suggestions and
requests. I don't know.

Any other ideas?

--
 Rom=E1n

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
