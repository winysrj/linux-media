Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.232])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steele.brian@gmail.com>) id 1KXnIX-0004By-Vs
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 03:24:43 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1915505rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 25 Aug 2008 18:24:36 -0700 (PDT)
Message-ID: <5f8558830808251824s153f4ed2wbfcb72a0eeddb364@mail.gmail.com>
Date: Mon, 25 Aug 2008 18:24:36 -0700
From: "Brian Steele" <steele.brian@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1219540819.11451.36.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
	<5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
	<1217791214.2690.31.camel@morgan.walls.org>
	<5f8558830808031428u3c9a8191tcd1705b27087f992@mail.gmail.com>
	<1217814427.23133.24.camel@palomino.walls.org>
	<5f8558830808051733w5960fb03p169ae2aa6d893ce8@mail.gmail.com>
	<1218074868.2689.34.camel@morgan.walls.org>
	<5f8558830808071830u4c8d882dse362748942ccec5b@mail.gmail.com>
	<1219540819.11451.36.camel@morgan.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 - No audio
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

On Sat, Aug 23, 2008 at 6:20 PM, Andy Walls <awalls@radix.net> wrote:
> Brian,
>
> v4l2-dbg didn't output the data I was expecting.  Here's a more explicit
> command line to try for me, if you could:
>
> # v4l2-apps/util/v4l2-dbg -d /dev/video0 -R type=host,chip=0,min=0x02c40000,max=0x2c409c7
>
> Substitute in the correct device node for /dev/video0 to access the
> cx23418 based card, if you more than 1 type of video capture card in
> your system.
>
> This will let me compare the setup of your CX23418's AV core with mine,
> to help me figure out where things may be failing for your tuner audio.
>

Hi Andy,

I got a new HVR-1600 with a different hardware revision (the one with
the FM tuner).  Sound works perfectly on the new card.  Hooray.  I
still have the old card for another few days.  If you are feeling
really motivated and want to track down the issue, I can put it into a
test system and run the command you asked for.  If you'd rather chalk
it up to faulty hardware I can certainly understand that.  Let me know
if you want me to do any further testing this week on the
non-functional card.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
