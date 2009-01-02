Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <412bdbff0901020715m15a685f6nb951030ae961e074@mail.gmail.com>
Date: Fri, 2 Jan 2009 10:15:31 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Albert Comerma" <albert.comerma@gmail.com>
In-Reply-To: <ea4209750901020701q11e34b42p3440c33e366fcb35@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <495A0E02.1030307@olenepal.org>
	<412bdbff0812300702l7f6333d0qa094332fc20f163@mail.gmail.com>
	<73e59df30901020653v5ec9b923mb5c6f4b186bb18de@mail.gmail.com>
	<ea4209750901020701q11e34b42p3440c33e366fcb35@mail.gmail.com>
Cc: pb@linuxtv.org, linux-dvb@linuxtv.org, don@syst.com.br,
	roshan karki <roshan@olenepal.org>
Subject: Re: [linux-dvb] YUAN High-Tech STK7700PH problem
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

On Fri, Jan 2, 2009 at 10:01 AM, Albert Comerma
<albert.comerma@gmail.com> wrote:
> Hi all, sorry for the delay, I didn't noticed the first mail. I added this
> patch, but I don't own any of this cards; the status was quite strange. One
> of the testers said that it was working perfectly while the other (there was
> not much people with that model) said it didn't work. So, I'm not sure if
> there is more than one hardware version with the same ID or something
> similar...
>
> Albert

Hello Albert,

As the person who submitted the original patch, thank you for taking
the time to respond.  From a debugging standpoint, it's good to know
that the support never worked, as opposed to some breakage being
introduced.

I'll look at Roshan's usb snoop trace over the weekend (unless you
want to).  I suspect the GPIOs are probably just not correctly for his
device and the demod is probably still being held in reset when the
first i2c command is sent.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
