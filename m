Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sub87-230-124-80.he-dsl.de ([87.230.124.80] helo=ts4.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@ts4.de>) id 1JgMpA-0002E5-T5
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 18:25:35 +0200
Received: from tom by ts4.de with local (Exim 4.62)
	(envelope-from <linux-dvb@ts4.de>) id 1JgMoa-00085R-G2
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 18:24:56 +0200
Date: Mon, 31 Mar 2008 18:24:56 +0200
From: Thomas Schuering <linux-dvb@ts4.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080331162456.GA30945@ts4.de>
References: <20080329134637.GA13258@ts4.de> <47EEEC06.5050705@shikadi.net>
	<20080330171555.GA22523@ts4.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080330171555.GA22523@ts4.de>
Subject: Re: [linux-dvb] [solved] Xcv2028/3028 init: general protection
	fault (was: DViCO Dual Digital 4 w/ Ubuntu 7.10/amd64 =>
	'general protection fault' by modprobe)
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

Hi,

the card seems to be broken.

On Sun, Mar 30, 2008 at 07:15:55PM +0200, Thomas Schuering wrote:
> 
> The init of xc2028 seg faults.

This happened when using 'hg clone http://linuxtv.org/hg/v4l-dvb'.

When I used 'hg clone http://linuxtv.org/hg/~pascoe/xc-test/'
instead the seg-faults were gone.

As I still didn't receive a signal from the card,
I asked a friend to install it under WinXP.

He couldn't get the card to work unter XP because of 'unkown errors',
He has no problems with his own dvb-t card, so I guess my card is broken. 


Regards, Thomas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
