Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <joerg.knitter@gmx.de>) id 1KiteD-0006r1-On
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 18:24:58 +0200
Message-ID: <48DBBAC0.7030201@gmx.de>
Date: Thu, 25 Sep 2008 18:22:24 +0200
From: =?ISO-8859-1?Q?J=F6rg_Knitter?= <joerg.knitter@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <002101c91f1a$b13c4e60$0401a8c0@asrock>
	<a3ef07920809250815k21948f99m7780e852088b96f@mail.gmail.com>
In-Reply-To: <a3ef07920809250815k21948f99m7780e852088b96f@mail.gmail.com>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements End-user point of
 viwer
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

VDR User wrote:
> 2008/9/25 Sacha <sacha@hemmail.se>:
>   =

>> Following your discussion from an end-user point of viwer I must say tha=
t I
>> wholy agree with this statement:
>>
>> <But 2 years to get a new API is really too much. And during these 2 yea=
rs,
>> 2
>>
>> <different trees for 2 differents drivers was totally insane. We
>> (applications
>>
>> <devs) are always making our best to bring DVB to users as easily as
>> possible.
>>
>> <And trust me, the multiproto story has complicated users life A LOT. Th=
is
>> must NEVER happen again.
>>
>> We, end-users want our stuff working now!
>>     =

>
> I assume you'd also like something that is well-designed, tested, and
> stable rather then slapped together and rushed...  But you know what
> they say about assumptions!
>   =


I have to agree with the claim Sacha said.

I am also "just" an end-user, got a TT3200 with VDR 1.7 working with all =

the guides and even wrote an article on it. But it was and is still a =

pain - for 2 years now.

With the introduction of the alternative S2API I was hoping that this =

long wait is over after waiting endlessly after the announcement, =

multiproto is ready "in a few weeks".

I have followed the discussion all the two (?) years, and I did just =

filter out information about, when the API could be ready, and I was =

shocked by all the really bad personal attacks that happened last year =

(or the year before) and the splits that results now in four =

"repositories" (kernel, multiproto, hvr4000-stuff and mcentral), often =

with dozens of patches postet here or at vdrportal that need to be =

applied to get a DVB card running.

And the main reasons for this is not really technical, it seems to me =

that they are personal. Open source projects claim to be better than =

commercial products, but the things that happened and currently happen =

are a good reason to see also the disadvantage of community development.

I understand all sides:
1) Manu does not want to to give up his work that he worked for long 2 =

years.
2) Markus Rechberger also did a lot of work, but I remember him to be =

very insulting to other developers - and quite uncooperative by starting =

his own tree. Linux development with MCC as leader might indeed be hard =

;)...
3) The S2API guys are fed up with all the waiting. Maybe there is indeed =

no technical reason behind the decision for S2API as I am also wondering =

why there is no answer to THE question. But waiting endlessly really is =

no solution...

The situation I see can not be solved by endless discussion, and even if =

MCC would switch to multiproto (again), there discussion would continue =

endlessly.

I just see two options to get a fair decision:
1) Allowing both APIs exist parallel for a short time and see who is the =

winner (as mentioned).
2) Let the community decide (all interested developers and even =

end-users like me and Sacha) with some kind of online vote. Communicate =

clearly before which "important" developer favours which API. As none of =

the API seems to have a real advantage/disadvantage, users like me will =

have to vote for both or decide on personal taste ;)

I favour option 2) as I also don=B4t like applications that rely on =

certain hardware (if only one API is supported).

With kind regards

Joerg Knitter

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
