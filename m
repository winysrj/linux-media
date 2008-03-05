Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <knowledgejunkie@gmail.com>) id 1JWxZ1-0008Sh-Jr
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 18:38:04 +0100
Received: by wf-out-1314.google.com with SMTP id 28so1905683wfa.17
	for <linux-dvb@linuxtv.org>; Wed, 05 Mar 2008 09:37:50 -0800 (PST)
Message-ID: <5387cd30803050937g2c089e88ycf388f5c2a85df52@mail.gmail.com>
Date: Wed, 5 Mar 2008 17:37:50 +0000
From: "Nick Morrott" <knowledgejunkie@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <4d2656190803050158i42fa956ck5b32d723474fea0a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <4d2656190803050158i42fa956ck5b32d723474fea0a@mail.gmail.com>
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

On 05/03/2008, Nikos Parastatidis <paranic@gmail.com> wrote:
> Hi there
>
>  i would like to ask you if it is posible to stream multiple channels
>  with any DVB-S card in linux.
>
>  do DVB-S have the capability to decode/tune to multiple channels?
>
>  i know this is not posible at DVB-T because of the tuner, it cannot
>  tune to multiple channels at once, you need dual or more pci cards to
>  do this.

As the other respondents have stated, it *is* possible with DVB-T and
DVB-S (and I guess probably possible with any other multiplexed format
that is not PID-filtered).

You should be able to tune to and record from other channels on the
same multiplex if your software allows. This is a key new feature of
the soon-to-be-released 0.21 version on MythTV.

Nick

-- 
Nick Morrott

MythTV Official wiki:
http://mythtv.org/wiki/
MythTV users list archive:
http://www.gossamer-threads.com/lists/mythtv/users

"An investment in knowledge always pays the best interest." - Benjamin Franklin

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
