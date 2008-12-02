Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jeffd@i2k.com>) id 1L7YKd-0006yf-R6
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 17:42:40 +0100
Date: Tue, 2 Dec 2008 11:42:02 -0500
From: Jeff DeFouw <jeffd@i2k.com>
To: djamil <djamil@djamil.net>
Message-ID: <20081202164202.GA18160@blorp.plorb.com>
References: <20081122195252.GA26727@blorp.plorb.com>
	<1228199374.7788.2.camel@toptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1228199374.7788.2.camel@toptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] notes and code for HVR-1800 S-Video
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

On Tue, Dec 02, 2008 at 07:29:34AM +0100, djamil wrote:
> I am trying to do the same thing on my HVR 1400, can you give me clues
> on how i can hack it up
> 
> I want to get analog working for svideo/composite inputs ...
> 
> Any tools under windows to spy on it ...

I used the RegSpy tool from DScaler:
http://www.dscaler.org/

It reads the PCI registers and tracks the changes.  You have to program 
the registers in and make it recognize your card.  I modified my copy to 
control one of the I2C units and read the I2C registers at the cx25840 
address.

-- 
Jeff DeFouw <jeffd@i2k.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
