Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [66.180.172.116] (helo=vps1.tull.net)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nick-linuxtv@nick-andrew.net>) id 1Jjjg8-0001sK-Ej
	for linux-dvb@linuxtv.org; Thu, 10 Apr 2008 01:26:09 +0200
Date: Thu, 10 Apr 2008 09:25:44 +1000
From: Nick Andrew <nick-linuxtv@nick-andrew.net>
To: Michael Krufky <mkrufky@gmail.com>
Message-ID: <20080409232544.GA31564@tull.net>
References: <200803292240.25719.janne-dvb@grunau.be>
	<37219a840804080818x729fd503ka3ba048c46169bcb@mail.gmail.com>
	<200804090022.40805@orion.escape-edv.de>
	<200804091121.22092.janne-dvb@grunau.be>
	<37219a840804090744l2fe7eacbncabd7a2ccf7979b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <37219a840804090744l2fe7eacbncabd7a2ccf7979b@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to	choose
	dvb adapter numbers, second try
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

On Wed, Apr 09, 2008 at 10:44:23AM -0400, Michael Krufky wrote:
> I believe that the "nr" abbreviation comes from the German language.
> (correct me if I'm wrong)

It also works in English as an abbreviation of NumbeR.

> Perhaps the abbreviation, "no" is more correct, since it is based on
> the English language, but to me this is of no significance, since v4l
> uses the "nr" abbreviation and this is globally understood.

I personally prefer 'nr' as an abbreviation for 'number' because it
uses letters in the word whereas with 'no' we have no bar to go under
the 'o' which is the correct printed form of the abbreviation. Also
'no' can be confused with the english word No.

However the complete kernel source uses '_no' about twice as much as
'_nr' and so for consistency with the rest of the kernel I can agree
with '_no'.

Nick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
