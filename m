Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Kixwg-0006cI-Vf
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 23:00:20 +0200
Received: by fk-out-0910.google.com with SMTP id f40so653421fka.1
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 14:00:15 -0700 (PDT)
Message-ID: <d9def9db0809251400r331c0667k733486a013eccefe@mail.gmail.com>
Date: Thu, 25 Sep 2008 23:00:15 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840809251340n7c588667xd18982f78e68a2ec@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <002101c91f1a$b13c4e60$0401a8c0@asrock>
	<a3ef07920809250815k21948f99m7780e852088b96f@mail.gmail.com>
	<48DBBAC0.7030201@gmx.de>
	<d9def9db0809251044k7fbcaa1awdf046edb2ca9b020@mail.gmail.com>
	<20080925181943.GA12800@halim.local>
	<a3ef07920809251139s41f26f14m76cff970c3373eb5@mail.gmail.com>
	<48DBF224.2010109@gmx.de>
	<37219a840809251340n7c588667xd18982f78e68a2ec@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements End-user point of
	view
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

On Thu, Sep 25, 2008 at 10:40 PM, Michael Krufky <mkrufky@linuxtv.org> wrot=
e:
> On Thu, Sep 25, 2008 at 4:18 PM, J=F6rg Knitter <joerg.knitter@gmx.de> wr=
ote:
>> VDR User wrote:
>>> Another option would be to look at both proposals, take the best ideas
>>> for each, and marry them into a new hybrid proposal so-to-speak.  By
>>> that I don't mean something which must be built completely from the
>>> ground up..  Most of the work has already been done.  I think that is
>>> a workable solution that can be found somewhere in the middle.
>>>
>> Thinking about all the posts within the last days, I did not propose
>> something as this as I don=B4t believe that certain persons are still
>> willing to cooperate or change their point of view. To be more precise:
>> I think it would be a wonder if Steven Toth and Manu Abraham worked
>> together. ;)
>>
>> With kind regards
>
> For the record, Manu did a great job with Multiproto.  Steve worked
> with the multiproto API and added driver support for his devices.
> Steve depended on Multiproto in order for his devices to work.  Steve
> asked Manu when he would merge into the master branch, and waited
> patiently for months.  Manu wouldn't even merge Steve's drivers into
> Manu's own multiproto tree.  After repeatedly asking him to merge with
> no sign of progress, Steve was left in a tough spot and had to come up
> with his own solution.
>
> There is a saying that goes often for Linux development... "release
> early, release often" ..  I first heard this saying from Johannes.  If
> you dont go by this way of thinking, ie:  hold on to code for two and
> a half years without allowing a merge, there is no guarantee that
> somebody else may come up with a better solution.
>
> There was no sign that Multiproto would _ever_ get merged.  All of us
> have waited for two and a half years for this.  The FIRST pull request
> from Manu only appeared after Steve posted his own API proposal.  Had
> Manu requested merge but one day before that, it would have been
> merged and that would have been the end of it.
>
> As it turns out, Steve's API is more flexible, and allows us to
> support more features than Multiproto allows.  If Manu would have
> allowed Multiproto to have been merged into the master branch, Steve
> would never have designed this newer API.  Due to the superior design,
> that was the chosen extension.  This is where we are left today.
>
> I hope that clears things up.
>

Julian put together a history (just because Michael keeps writing the same):
http://lkml.org/lkml/2008/9/19/67

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
