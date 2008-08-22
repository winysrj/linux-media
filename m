Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n64.bullet.mail.sp1.yahoo.com ([98.136.44.189])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KWP0P-0000Dt-2F
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 07:16:18 +0200
Date: Thu, 21 Aug 2008 22:15:37 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Josef Wolf <jw@raven.inka.de>, Kevin Sheehan <linux-dvb@ephedrine.net>
In-Reply-To: <52113.203.82.187.131.1219367267.squirrel@webmail.planb.net.au>
MIME-Version: 1.0
Message-ID: <271833.9641.qm@web46109.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
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

--- On Fri, 8/22/08, Kevin Sheehan <linux-dvb@ephedrine.net> wrote:

> Barry was right on the money with the ts2ps suggestion below.  It's part
> of the libdvb package.  You don't have to use the dvb-mpegtools app, you
> can just use the lib in yours - no pipes, etc.

Actually, I either need to decide to finish waking up, or get more
sleep before trying to think, but I did learn something new from
this conversation...

My understanding of a PS stream (redundant, yeah) was based on how
ts2ps created one, with just two PIDs (0xe0 and 0xc0), which I then
assumed was the norm.

But in the case of ZDF from the original post, as well as ARD, BR,
Sat1, and so on, Josef wants to make the multiple available audio
streams from the TS (primary mp2 audio, second narrative audio/
second lang, plus AC3) within the PS for the client to select.

I'd imagine a bit of hacking is needed to ts2ps to allow one to add
more than a single audio PID to the PS, but it should be possible.

But, if there's a need for, say, the DVB subtitles from ZDF, or the
teletext (for teletext subtitles, amongst others), or any other
auxiliary data within the stream, if I understand right, one would
need to stick to writing a partial transport stream, which then
could be filtered to PS as needed.

Of course, I could be wrong, as I'm not too familiar with libdvb...



sleeeeeeep...
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
