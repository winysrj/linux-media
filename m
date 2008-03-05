Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter@naiadhome.com>) id 1JWzU8-0001Vf-Ab
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 20:41:05 +0100
Message-ID: <001601c87ef8$c5d6ff90$160fa8c0@sloop>
From: "Peter Martin" <peter@naiadhome.com>
To: "Nikos Parastatidis" <paranic@gmail.com>,
	<linux-dvb@linuxtv.org>
References: <4d2656190803050158i42fa956ck5b32d723474fea0a@mail.gmail.com><15e616860803050314j3e3e88fbnee5edfddcf895aac@mail.gmail.com><47CE88E7.5070508@bulteel.org><4d2656190803050358r434c215i81201cec3df16e65@mail.gmail.com>
	<4d2656190803050422w69f85866h8f6d6439fe60a64c@mail.gmail.com>
Date: Wed, 5 Mar 2008 19:40:30 -0000
MIME-Version: 1.0
Subject: Re: [linux-dvb] DVB-S Stream multiple Channels
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

---- Original Message ----- 
From: "Nikos Parastatidis" <paranic@gmail.com>
To: <linux-dvb@linuxtv.org>
Sent: Wednesday, March 05, 2008 12:22 PM
Subject: Re: [linux-dvb] DVB-S Stream multiple Channels


>i see !
> this creared everything now
> so DVB-S has a tuner also
>
> i thoght it was one frequency for every LNB and every satelite
> and with this frequency was a carrier for all channels.
>
> anyway ok in theory
> but are there frequencies that cary more than one channel?
> can someone give me an excample like Patrick gave me on DVB-T
> if you can speak Greek :-) and give me a nova excample it would be great 
> :-)
To see what channels are available, I have always found sites like 
www.satcodx.com and www.lygsat.com useful to see what is available on 
individual satellites/transponders.

Pete

>
> how can i check it my self within dreambox ?
> how can i check if one freq has many channels?
>
> Thanks in advance
> your help so far was very precius.
>
>
>
>
>
>> On 3/5/08, Patrick Bulteel <linuxtv@bulteel.org> wrote:
>> >
>> > Zaheer Merali wrote:
>> > > On Wed, Mar 5, 2008 at 9:58 AM, Nikos Parastatidis 
>> > > <paranic@gmail.com> wrote:
>> > >> Hi there
>> > >>
>> > >>  i would like to ask you if it is posible to stream multiple 
>> > >> channels
>> > >>  with any DVB-S card in linux.
>> > >>
>> > >>  do DVB-S have the capability to decode/tune to multiple channels?
>> > >>
>> > >>  i know this is not posible at DVB-T because of the tuner, it cannot
>> > >>  tune to multiple channels at once, you need dual or more pci cards 
>> > >> to
>> > >>  do this.
>> > >>
>> > >>  what about at DVB-S ?
>> > >>
>> > >>
>> > >>  Thanks in advace
>> > >>  Parastatidis Nikos
>> > >
>> > > Nikos, if they are on the same transponder/multiplex you can stream
>> > > multiple channels. If not you need a different tuner per channel.
>> > >
>> > > Zaheer
>> > >
>> >
>> > And I believe that applies for DVB-T as well. Meaning with one tuner in
>> > the UK you should be able to tune/stream the following on
>> > Mux 1: BBC ONE, BBC TWO, BBC THREE / CBBC, BBC NEWS 24
>> >
>> > and so on...
>> >
>> >
>> > --
>> > Patrick
>> >
>>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
> -- 
> No virus found in this incoming message.
> Checked by AVG Free Edition.
> Version: 7.5.516 / Virus Database: 269.21.4/1310 - Release Date: 
> 04/03/2008 08:35
>
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
