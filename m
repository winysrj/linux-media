Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mattvermeulen@gmail.com>) id 1JRpEP-0000mb-AT
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 14:43:29 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2153949wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 05:43:25 -0800 (PST)
Message-ID: <950c7d180802200543w31d157eag6e3d8277d60fa412@mail.gmail.com>
Date: Wed, 20 Feb 2008 22:43:24 +0900
From: "Matthew Vermeulen" <mattvermeulen@gmail.com>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1203513814.6682.30.camel@acropora>
MIME-Version: 1.0
References: <1203434275.6870.25.camel@tux> <1203441662.9150.29.camel@acropora>
	<1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203495773.7026.15.camel@tux> <1203496068.7026.19.camel@tux>
	<950c7d180802200436s68bab78ej3eb01a93090c313f@mail.gmail.com>
	<1203513814.6682.30.camel@acropora>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0975626884=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0975626884==
Content-Type: multipart/alternative;
	boundary="----=_Part_9507_7414927.1203515004677"

------=_Part_9507_7414927.1203515004677
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry forgot to reply to teh list....

On Feb 20, 2008 10:34 PM, Filippo Argiolas <filippo.argiolas@gmail.com>
wrote:
2008/2/20, Matthew Vermeulen <mattvermeulen@gmail.com>:
> Ok - just thought I'd try the patch on the latest tree and see what
> happens... as expected, it put an end to the syslog flooding - but nothing
> really has improved... I still see a single error line in the syslog every
> time I press a key - so obviously the kernel is seeing something happen,
but
> deciding it's unknown and not taking it any further. Something must be
wrong
> with some mappings somewhere.. :S Here's the syslog output anyway - there
is
> one line for every key press:
>
> Feb 20 22:07:07 matthew-desktop kernel: [38161.388548] dib0700: Unknown
> remote controller key: 12 7E  1  0
> Feb 20 22:07:09 matthew-desktop kernel: [38162.678839] dib0700: Unknown
> remote controller key: 18 7C  1  0
>  Feb 20 22:07:10 matthew-desktop kernel: [38162.906413] dib0700: Unknown
> remote controller key: 18 7C  1  0
> Feb 20 22:07:14 matthew-desktop kernel: [38165.183338] dib0700: Unknown
> remote controller key: 1C 4D  1  0
> Feb 20 22:07:18 matthew-desktop kernel: [38167.156040] dib0700: Unknown
> remote controller key: 1F 7D  1  0
>  Feb 20 22:07:21 matthew-desktop kernel: [38168.598632] dib0700: Unknown
> remote controller key: 19 43  1  0
>
> This is very annoying because it seems that polling the syslog every 150ms
> might even give you something if you could work it out ;) Anyway.. any
ideas
> where to now...?

Ok, I didn't take a look at your previous messages, so I was thinking
you were trying to make a hauppauge remote work. As far as I can see
from this output and from dib0700 code your remote is not supported,
hence there is no keymap hardcoded for it, hence the drivers outputs
"unknow key" since it really doesn't know what to do with the key
received.
Looking at your log it seems even that your remote is not an rc5
standard one since the toggle bit is always set to 1. Please try to
press the same key many times (do not hold it down) and look if the
unknown key is always the same and if the 3rd value changes
alternatively from 0 to 1. If everything is ok you can start to take
note of the values outputed by your keys and try to add a keymap on
your own or send the results here. Note that if toggle bit is not
working properly it the repeat feature would not work perfectly.
I cannot do anything more since I don't have that remote control to
make some test.

Filippo
Hmm...

Maybe you can make more sense of this - the is the result of pressing the
same key repeatedly very rapidly (ie as fast as i can ;) )

Feb 20 22:39:48 matthew-desktop kernel: [39332.403671] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:48 matthew-desktop kernel: [39332.555469] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:48 matthew-desktop kernel: [39332.631930] dib0700: Unknown
remote controller key: 1F  A  1  0
Feb 20 22:39:48 matthew-desktop kernel: [39332.707392] dib0700: Unknown
remote controller key:  F 39  0  0
Feb 20 22:39:48 matthew-desktop kernel: [39332.783229] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:49 matthew-desktop kernel: [39332.859565] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:49 matthew-desktop kernel: [39333.010863] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:49 matthew-desktop kernel: [39333.086825] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:49 matthew-desktop kernel: [39333.238810] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:49 matthew-desktop kernel: [39333.315022] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:50 matthew-desktop kernel: [39333.390859] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:50 matthew-desktop kernel: [39333.542656] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:50 matthew-desktop kernel: [39333.618559] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:50 matthew-desktop kernel: [39333.694392] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:51 matthew-desktop kernel: [39333.846254] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:51 matthew-desktop kernel: [39333.922152] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:51 matthew-desktop kernel: [39333.998053] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:51 matthew-desktop kernel: [39334.149849] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:51 matthew-desktop kernel: [39334.225750] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:51 matthew-desktop kernel: [39334.301647] dib0700: Unknown
remote controller key: 1F  A  1  0
Feb 20 22:39:52 matthew-desktop kernel: [39334.453384] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:52 matthew-desktop kernel: [39334.529281] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:52 matthew-desktop kernel: [39334.681017] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:53 matthew-desktop kernel: [39334.832815] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:53 matthew-desktop kernel: [39334.908277] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:53 matthew-desktop kernel: [39335.060139] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:53 matthew-desktop kernel: [39335.136473] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:53 matthew-desktop kernel: [39335.211810] dib0700: Unknown
remote controller key: 13 7E  1  0
Feb 20 22:39:54 matthew-desktop kernel: [39335.364108] dib0700: Unknown
remote controller key: 13 7E  1  0

Not sure if that's what we were hoping for...

If it's going to help i can write out exactly what keys map to what code...

Cheers,

MAtt


-- 
Matthew Vermeulen
http://www.matthewv.id.au/
MatthewV @ irc.freenode.net

------=_Part_9507_7414927.1203515004677
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry forgot to reply to teh list....<br><br>On Feb 20, 2008 10:34 PM, Filippo Argiolas &lt;<a href="mailto:filippo.argiolas@gmail.com" target="_blank">filippo.argiolas@gmail.com</a>&gt; wrote:<br>
2008/2/20, Matthew Vermeulen &lt;<a href="mailto:mattvermeulen@gmail.com" target="_blank">mattvermeulen@gmail.com</a>&gt;:<br><div>&gt; Ok - just thought I&#39;d try the patch on the latest tree and see what<br>&gt; happens... as expected, it put an end to the syslog flooding - but nothing<br>

&gt; really has improved... I still see a single error line in the syslog every<br>&gt; time I press a key - so obviously the kernel is seeing something happen, but<br>&gt; deciding it&#39;s unknown and not taking it any further. Something must be wrong<br>

&gt; with some mappings somewhere.. :S Here&#39;s the syslog output anyway - there is<br>&gt; one line for every key press:<br>&gt;<br>&gt; Feb 20 22:07:07 matthew-desktop kernel: [38161.388548] dib0700: Unknown<br>&gt; remote controller key: 12 7E &nbsp;1 &nbsp;0<br>

&gt; Feb 20 22:07:09 matthew-desktop kernel: [38162.678839] dib0700: Unknown<br>&gt; remote controller key: 18 7C &nbsp;1 &nbsp;0<br>&gt; &nbsp;Feb 20 22:07:10 matthew-desktop kernel: [38162.906413] dib0700: Unknown<br>&gt; remote controller key: 18 7C &nbsp;1 &nbsp;0<br>

&gt; Feb 20 22:07:14 matthew-desktop kernel: [38165.183338] dib0700: Unknown<br>&gt; remote controller key: 1C 4D &nbsp;1 &nbsp;0<br>&gt; Feb 20 22:07:18 matthew-desktop kernel: [38167.156040] dib0700: Unknown<br>&gt; remote controller key: 1F 7D &nbsp;1 &nbsp;0<br>

&gt; &nbsp;Feb 20 22:07:21 matthew-desktop kernel: [38168.598632] dib0700: Unknown<br>&gt; remote controller key: 19 43 &nbsp;1 &nbsp;0<br>&gt;<br>&gt; This is very annoying because it seems that polling the syslog every 150ms<br>&gt; might even give you something if you could work it out ;) Anyway.. any ideas<br>

&gt; where to now...?<br><br></div>Ok, I didn&#39;t take a look at your previous messages, so I was thinking<br>you were trying to make a hauppauge remote work. As far as I can see<br>from this output and from dib0700 code your remote is not supported,<br>

hence there is no keymap hardcoded for it, hence the drivers outputs<br>&quot;unknow key&quot; since it really doesn&#39;t know what to do with the key<br>received.<br>Looking at your log it seems even that your remote is not an rc5<br>

standard one since the toggle bit is always set to 1. Please try to<br>press the same key many times (do not hold it down) and look if the<br>unknown key is always the same and if the 3rd value changes<br>alternatively from 0 to 1. If everything is ok you can start to take<br>

note of the values outputed by your keys and try to add a keymap on<br>your own or send the results here. Note that if toggle bit is not<br>working properly it the repeat feature would not work perfectly.<br>I cannot do anything more since I don&#39;t have that remote control to<br>

make some test.<br><font color="#888888"><br>Filippo</font><br>Hmm...<br><br>Maybe you can make more sense of this - the is the result
of pressing the same key repeatedly very rapidly (ie as fast as i can
;) )<br>
<br>Feb 20 22:39:48 matthew-desktop kernel: [39332.403671] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:48 matthew-desktop kernel: [39332.555469] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>

Feb 20 22:39:48 matthew-desktop kernel: [39332.631930] dib0700: Unknown remote controller key: 1F&nbsp; A&nbsp; 1&nbsp; 0<br>Feb 20 22:39:48 matthew-desktop kernel: [39332.707392] dib0700: Unknown remote controller key:&nbsp; F 39&nbsp; 0&nbsp; 0<br>
Feb 20 22:39:48 matthew-desktop kernel: [39332.783229] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:49 matthew-desktop kernel: [39332.859565] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:49 matthew-desktop kernel: [39333.010863] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:49 matthew-desktop kernel: [39333.086825] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:49 matthew-desktop kernel: [39333.238810] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:49 matthew-desktop kernel: [39333.315022] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:50 matthew-desktop kernel: [39333.390859] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:50 matthew-desktop kernel: [39333.542656] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:50 matthew-desktop kernel: [39333.618559] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:50 matthew-desktop kernel: [39333.694392] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:51 matthew-desktop kernel: [39333.846254] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:51 matthew-desktop kernel: [39333.922152] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:51 matthew-desktop kernel: [39333.998053] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:51 matthew-desktop kernel: [39334.149849] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:51 matthew-desktop kernel: [39334.225750] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:51 matthew-desktop kernel: [39334.301647] dib0700: Unknown remote controller key: 1F&nbsp; A&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:52 matthew-desktop kernel: [39334.453384] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:52 matthew-desktop kernel: [39334.529281] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:52 matthew-desktop kernel: [39334.681017] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:53 matthew-desktop kernel: [39334.832815] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:53 matthew-desktop kernel: [39334.908277] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:53 matthew-desktop kernel: [39335.060139] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:53 matthew-desktop kernel: [39335.136473] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:39:53 matthew-desktop kernel: [39335.211810] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
Feb 20 22:39:54 matthew-desktop kernel: [39335.364108] dib0700: Unknown remote controller key: 13 7E&nbsp; 1&nbsp; 0<br>
<br>Not sure if that&#39;s what we were hoping for...<br><br>If it&#39;s going to help i can write out exactly what keys map to what code...<br><br>Cheers,<br><br>MAtt<br><br clear="all"><br>-- <br>Matthew Vermeulen<br><a href="http://www.matthewv.id.au/">http://www.matthewv.id.au/</a><br>
MatthewV @ <a href="http://irc.freenode.net">irc.freenode.net</a>

------=_Part_9507_7414927.1203515004677--


--===============0975626884==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0975626884==--
