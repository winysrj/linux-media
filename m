Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n74b.bullet.mail.sp1.yahoo.com ([98.136.45.47])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KaVls-0008Qe-Ho
	for linux-dvb@linuxtv.org; Tue, 02 Sep 2008 15:18:17 +0200
Date: Tue, 2 Sep 2008 06:17:38 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Jiri Jansky <janskj1@fel.cvut.cz>
In-Reply-To: <48BC1323.9030709@fel.cvut.cz>
MIME-Version: 1.0
Message-ID: <240816.27282.qm@web46109.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB Opera DVB-S 1 and diseqc switch
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

--- On Mon, 9/1/08, Jiri Jansky <janskj1@fel.cvut.cz> wrote:

Nazdar!

> It's 4/1 DiseqC 2.0 switch.
> 
> On linux, I download firmware files from hompege of driver author 

Here is what I have, as I cannot remember how I got them:
-rw-r--r-- 1 beer besoffen 55024 2007-09-27 20:29 dvb-usb-opera1-fpga-01.fw
-rw-r--r-- 1 beer besoffen  9439 2007-09-27 20:29 dvb-usb-opera-01.fw



I do not have presently a sat setup that does not feed my
multiswitch, but I have too many 2/1 and 4/1 DiSEqC switches
from the time before I switched over to the multiswitch.

So, what I did was connect one 2.0 4/1 and several un-marked
4/1 as well as a marked 1.1 2/1 (committed) switches to the
Opera tuner, and then connect a sat-finder (with light and
tone) to different inputs to indicate that the switch is
delivering a voltage to that sat-input-position, and one of
the outputs from the multiswitch to another switch input which
would give a signal, presumably from the first input to the
multiswitch, but often itself switched with certain switches
(normally you can't cascade switches like this successfully).

Then I ran a script I have which allows me to tune and listen
to the audio from a selected station, and further allows me to
override the sat position with `-D1' to `-D4' (yes, hacked).

I did not get the proper switch input selected all the time
with most switches.  But, sometimes I did.


Also, I just ran my tuning/scan script, which starts a new
`scan' for each of a list of frequencies, but which does not
switch between sat positions.

For sat position 4, less than half the time, did the voltage
appear on that output.  For position 3, it seemed to be almost
perfect until some mysterious kernel panic.  At position two,
it was mostly correct but there seemed to be a few times that
the switch was sending the voltage somewhere else.


If I were motivated, I would wire up a simple LED indicator to
show me the voltage (and 22kHz?) status of all sat inputs, to
know which input was active at that time.


It looks to me that the Opera tuner *can* switch at least some
4/1 DiSEqC switches, at least partly correctly.  But there seem
to be some problems, which may be in part because I am not using
a real switched LNB setup.


Also, I have had some problems with some of these switches in
the past, when I was switching between multiple LNBs, with
different tuner cards and receivers.  In particular, often if
the switch were located at the end of tens of metres of cable,
the DiSEqC signal would be too weak and would be unable to select
inputs B, C, or D with certain cards/receivers.  With today's
test, I have about 1m cable from the Opera to the switch.


If you are able to receive a particular station from position
A (-D 0 for unhacked code, I think), and can still receive this
same channel for all other values of -D1 and up, then you aren't
switching.  However, often I saw input C active with (in my case)
-D4 and -D2 and sometimes -D1, and other times not, so often I
was seeing the wrong switch input selected -- but not consistently.


If I manage to set up a multi-LNB+switch dish sometime soon, I
will try to remember to test again, because I do not trust my
test results with just the sat-finder.


I hope this is helpful...

barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
