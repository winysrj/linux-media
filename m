Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LJX0v-0002tL-PB
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 18:43:51 +0100
From: Andy Walls <awalls@radix.net>
To: Eric Bauer <ebauer71@centurytel.net>
In-Reply-To: <4960D592.9070400@centurytel.net>
References: <4960D592.9070400@centurytel.net>
Date: Sun, 04 Jan 2009 12:46:02 -0500
Message-Id: <1231091162.3125.6.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem Searching Channels
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

On Sun, 2009-01-04 at 09:28 -0600, Eric Bauer wrote:
> Hello,
> 
> I'm trying to set up my new Happaugue HVR-1600 card.  During the scan, 
> II get several minutes of output on the screen complaining about tuning 
> failures,

These are normal when no service is detected on those freqs.


>  and then I get the following message:
> 
> start filter:1338: ERROR: ioctl DMX_SET_FILTER failed: 6 No such device 
> or address

Hmmm.  New one one me, I'll have to investigate.

What specific tool, version and command line arguments are you using?


> I have to kill the scan with a control-c at this point.  Can anyone give 
> me some advice with this problem?

Make sure you are using the latest cx18 driver from:

http://linuxtv.og/hg/v4l-dvb

versions older than v1.0.4 of the cx18 driver have problems dealing with
the occasional PCI bus error.


Instructions can be found here:

http://www.ivtvdriver.org/index.php/Cx18


Make sure you have a good clean signal coming in:

http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality


Regards,
Andy

> Thanks,
> 
> Eric



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
