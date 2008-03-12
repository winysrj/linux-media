Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qb-out-0506.google.com ([72.14.204.233])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zaheermerali@gmail.com>) id 1JZQAw-00041q-Ts
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 13:35:21 +0100
Received: by qb-out-0506.google.com with SMTP id o12so2454392qba.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 05:35:02 -0700 (PDT)
Message-ID: <15e616860803120535v709222at9a38b41b2daedb60@mail.gmail.com>
Date: Wed, 12 Mar 2008 12:35:01 +0000
From: "Zaheer Merali" <zaheermerali@gmail.com>
To: "Stephen Rowles" <stephen@rowles.org.uk>
In-Reply-To: <21776.81.144.130.125.1205324398.squirrel@manicminer.homeip.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <000f01c8842b$a899efe0$f9cdcfa0$@com>
	<21776.81.144.130.125.1205324398.squirrel@manicminer.homeip.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Implementing support for multi-channel
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

On Wed, Mar 12, 2008 at 12:19 PM, Stephen Rowles <stephen@rowles.org.uk> wrote:
>
> > Hello,
>  >
>  > I was wondering if there's some info to find on how to implement (and
>  > test)
>  > multi-channel receiving?
>  > It's possible, because dvb uses streams and the driver is currently
>  > capable
>  > to filter one channel, but how can I implement the support of
>  > multi-channel
>  > filtering?
>  > Is there perhaps an open-source driver supporting this that I can have a
>  > look at?
>
>  Check out the dvbstreamer project:
>
>  http://dvbstreamer.sourceforge.net/
>
>  This allows multi-channel recording / streaming if the DVB device supports
>  sending the whole transport stream (some usb devices do not support this).
>  This works by sending the whole transport stream to the dvbstreamer
>  program, then this program allows filtering out and recording separate
>  channels from that stream as required.
>
>  This isn't a driver level solution, but might provide the function you need.
>
>

Read this blog post, this solution does not take the full stream but
just filters the pids it requires for the different channels allowing
it to work on most USB devices also.

http://zaheer.merali.org/articles/2008/02/29/multiple-dvb-channels-streamed-by-flumotion-from-same-capture-card/

Zaheer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
