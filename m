Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n74.bullet.mail.sp1.yahoo.com ([98.136.44.186])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KCGTH-0004J0-Gu
	for linux-dvb@linuxtv.org; Fri, 27 Jun 2008 18:06:50 +0200
Date: Fri, 27 Jun 2008 09:06:11 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Michael Krufky <mkrufky@gmail.com>
In-Reply-To: <37219a840806270738u6a456c95q4699b67e03210f98@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <417831.54873.qm@web46116.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with Terratec Cinergy Piranha
Reply-To: free_beer_for_all@yahoo.com
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

--- On Fri, 6/27/08, Michael Krufky <mkrufky@gmail.com> wrote:

> > That's your mistake -- now for DVB-T the default mode needs to be
> > left as 4 (that's DVBT-DBA-drivers; how that specifically differs

> This is an experimental driver -- You'll notice that I did not merge
> it into the master branch yet -- those alternative modes are for
> external software applications, to use the driver in a way without
> using the dvb core framework.

Which brings me to ask publicly what I've been trying to figure
out how to ask...

The device supports DAB under the supplied Home Cinema Windows
application, the reason why I bought it (DAB support, that is.
I have no Windows boxes).  It works and all.

DAB is about as far from DVB as, well, as it is.  There's one
DAB device support sourcefile, under video or something, but it
doesn't seem to deal with the composition of the multiplex
datastream.  Where is it appropriate for me to ask questions
about DAB, if anywhere?  Shirley, not this list...

And secondly, has anyone who has this adapter and can receive
DAB radio with it, captured that protocol and data and whatnot,
to enable some reverse-engineering/hacking?

Basically, I'm wondering, what does a non-DVB external software
need to say to the device, and what does the device say in return
(complete multiplex data, or only part thereof, or something),
in order to tune and listen to a DAB multiplex/channel...



> > There appears to be another copy of the smsdvb code in a repository
> > called somehow `*CENSORED*' which differs slightly;

> That code is not for you :-P

Sorry guv, i'm overwriting my downloaded copy thereof repeatedly
with a random pattern of ones and zeroes formed by the statistical
cryptographic transformation (and computationally mathematically
proven, say wot) based on the highly sophisticated algorithm of
ROT-26ing the data, so you can rest assured I shan't poke my nose
in places it does not belong, until the next time I see something
curiously interesting


> You think you needed the adapter_nr compat patch, but you dont -- if
> you build from the "siano" tree, it will install the newer dvb-core
> along with the adapter_nr interface.

And it will also overwrite the hacked source I have in my present
kernel that enables a few obscure devices I have to function at all,
so I'm hoping to clear out all my accumulated hacks before I can
safely try a stock kernel again.  That's the unfortunate reason
I'm cherry-picking the best goodies out of new code selectively.

No worries, I'm clearing out my hacks, hopefully before I get
cleared out


thanks
barry bouwmsa


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
