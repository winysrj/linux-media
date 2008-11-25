Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1L50qO-0005wY-8Z
	for linux-dvb@linuxtv.org; Tue, 25 Nov 2008 17:32:59 +0100
Received: by ey-out-2122.google.com with SMTP id 25so24539eya.17
	for <linux-dvb@linuxtv.org>; Tue, 25 Nov 2008 08:32:53 -0800 (PST)
Message-ID: <a3ef07920811250832g35f4670ft4e14c942c3eef990@mail.gmail.com>
Date: Tue, 25 Nov 2008 08:32:52 -0800
From: "VDR User" <user.vdr@gmail.com>
To: "Klaus Schmidinger" <Klaus.Schmidinger@cadsoft.de>
In-Reply-To: <492BBFD9.50909@cadsoft.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>
	<492BBFD9.50909@cadsoft.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

On Tue, Nov 25, 2008 at 1:05 AM, Klaus Schmidinger
<Klaus.Schmidinger@cadsoft.de> wrote:
> I find it a completely unacceptable thing to have the user tell
> the application what type of DVB devices the hardware provides.
> This is pretty much the first and simplest thing the *DRIVER* has
> to do. If a driver (API) doesn't allow this in a clean way, it's
> worthless!
>
> I don't care if this is a specific or a general flag, as long as
> it allows the application to clearly find out the kind of hardware
> that's available. It leaves me dumbfounded that this is suddenly
> such a big problem...

You are not alone in that boat my friend.  Especially after reading
the comments about how "thought out" the api is.  How could you
possibly miss such a fundamental element?!

> If my proposal is not acceptable, then please can one of the S2API
> experts come up with a solution that better fits the S2API way of
> thinking?

I have yet to hear any response from any of them about this issue.
Seems as though when the issue was beating multiproto, communication
was at the peak.  Now that the decision has been made, good luck to
get a reply.  :\

> <conspiracy_theory><sarcasm>
> Or is the S2API already "dead", and it's sole purpose was to
> prevent "multiproto" to make its way into the kernel? And now that
> this has been achieved, nodody really cares whether it can be used
> in real life?
> </sarcasm></conspiracy_theory>

Hey, stranger things have happened.  Not much surprised me these days.
 Hopefully somebody will get this sorted out and fixed very soon as it
shouldn't even be an issue at this point!!

-Derek

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
