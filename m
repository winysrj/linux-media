Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpd4.aruba.it ([62.149.128.209] helo=smtp3.aruba.it)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <a.venturi@avalpa.com>) id 1Jw1At-000433-1O
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 22:32:42 +0200
Message-ID: <4829FAC4.2000707@avalpa.com>
Date: Tue, 13 May 2008 22:32:04 +0200
From: Andrea Venturi <a.venturi@avalpa.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] RE : inserting user PIDs in TS
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

Thierry Lelegard wrote:

>
>
>> I would like to know that can we insert user defined PIDs into the TS
>> stream. how should i go about? What standard should i follow? How
should I
>> format the the packets ( segment - section etc...).
>> can any body help in this regard.
>
> Yes, in theory, you can.
>
> Keep in mind, however, that multiplexing is a quite difficult job
> (this is what multiplexers are made for).

hi,

if i can suggest a starting point, there's already a free software
project for transport stream manipulation; it's called JustDVb-It, the
GPL licensed package we made in our previous company Cineca since 2004:

 http://www.cineca.tv/labs/mhplab/JustDVb-It%202.0.html

it's a set of simple tools (following unix filosophy) you can put
together in some customized ways to accomplish complex tasks.

for example, it can filter PID on a TS, swap some PIDs with others,
transform python described PSI tables in sections then in TS packets,
and create DSMCC carousels too..

there's a live CD to demo it with a DVB ASI port in a sample
configuration (for italian MHP based interactive television)

the current version can't restamp PCR, as it's quite a complex task, but
this feature is something that we are releasing RSN in our new-born
start-up Avalpa (http://www.avalpa.com). stay tuned!

HTH

bye

andrea venturi



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
