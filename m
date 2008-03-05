Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zaheermerali@gmail.com>) id 1JWraD-0006Ra-TL
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 12:14:50 +0100
Received: by wf-out-1314.google.com with SMTP id 28so1678063wfa.17
	for <linux-dvb@linuxtv.org>; Wed, 05 Mar 2008 03:14:33 -0800 (PST)
Message-ID: <15e616860803050314j3e3e88fbnee5edfddcf895aac@mail.gmail.com>
Date: Wed, 5 Mar 2008 11:14:31 +0000
From: "Zaheer Merali" <zaheermerali@gmail.com>
To: "Nikos Parastatidis" <paranic@gmail.com>
In-Reply-To: <4d2656190803050158i42fa956ck5b32d723474fea0a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <4d2656190803050158i42fa956ck5b32d723474fea0a@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
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

On Wed, Mar 5, 2008 at 9:58 AM, Nikos Parastatidis <paranic@gmail.com> wrote:
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
>
>  what about at DVB-S ?
>
>
>  Thanks in advace
>  Parastatidis Nikos

Nikos, if they are on the same transponder/multiplex you can stream
multiple channels. If not you need a different tuner per channel.

Zaheer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
