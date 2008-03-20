Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jc8Vz-0004em-G9
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 01:20:17 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 20 Mar 2008 01:18:26 +0100
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<Pine.LNX.4.62.0803141819410.8859@ns.bog.msu.ru>
	<Pine.LNX.4.62.0803171305520.18849@ns.bog.msu.ru>
In-Reply-To: <Pine.LNX.4.62.0803171305520.18849@ns.bog.msu.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803200118.26462@orion.escape-edv.de>
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
	transponder fails
Reply-To: linux-dvb@linuxtv.org
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

ldvb@ns.bog.msu.ru wrote:
> Could somebody help with ideas, why there are mistakes in the channel when 
> using H pol. on the TT S-1401 card (while V works fine)?
> I do not know where and how to start digging the problem.
> On Windows everything is fine.
> Frequencies: H is 11043, V is 11606, symb. rate 44948.
> Total bitrate is approx. 68Mbit.

If the same machine/card/cable works with windows, and does not work
with the linux driver, there must be an issue in the driver.

Unfortunately, this is a common problem because most vendors do not
support linux. So many drivers are sub-optimal.

Sorry, if you want to have your problem fixed, you have dig through the
register programming of the frontend driver. Use an i2c sniffer and
compare the register settings of the the windows driver with those of
the linux driver...

If you want to experiment with some parameters, you might have a look at
changeset
  http://linuxtv.org/hg/v4l-dvb/rev/8a19aa788239
Maybe you can find a better register setting which fixes your problem.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
