Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <primijos@gmail.com>) id 1K4FZI-00049H-Hc
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 15:31:53 +0200
Received: by rn-out-0910.google.com with SMTP id m36so189109rnd.2
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 06:31:48 -0700 (PDT)
Message-ID: <aea1a9c0806050631m3755582djbd7cf15481910310@mail.gmail.com>
Date: Thu, 5 Jun 2008 15:31:47 +0200
From: "=?ISO-8859-1?Q?Jos=E9_Oliver_Segura?=" <primijos@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <200806051148.07529.bumkunjo@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <aea1a9c0806050050v4db695c6jef6b19421f617c4d@mail.gmail.com>
	<200806051148.07529.bumkunjo@gmx.de>
Subject: Re: [linux-dvb] dual tuner,
	different behaviour/signal strength problem
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

On Thu, Jun 5, 2008 at 11:48 AM, jochen s <bumkunjo@gmx.de> wrote:
>
> just an idea -  is the throughput over USB of the 'bad' channel combination
> (or on channel 0) higher or different to other combinations? can you exclude
> USB-issues being the cause? for example AMD's SB600 and Hauppauge Nova-TD
> don't work correctly together

Hi jochen,

thanks for your quick response. I'm not sure how to measure the USB
throughput of the 'bad' channel combination. What I've tried to do is
test simultaneous tuning of different channels on both receivers (the
two inside the pinnacle), and most of them (actualy, all my tests)
work ok.

About those tests, I've found something new, and thus I'm replying
directly to the list in order to give more information to anyone that
can give some light about this:

* Tuning different channels from different multiplexes on the two
tuners inside the pinnacle stick *always* cause an increment on the
BER field in the receiver-1 (tzap or femon output), but not enough to
make UNC be different than 0 (I assume they can be corrected OK)

* Tuning different channels from *the same* multiplex on the two
tuners makes BER grow up *in both* tuners: one of them (tuner-0, the
one attached to the back antenna connector) still offering good
quality (no UNC), but the other one starts to produce glitches (UNC >
0)

So it looks like, in some way, the fact of the two channels being on
the same multiplex has some influence?

Again, any help would be welcome, thanks in advance,
Jose

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
