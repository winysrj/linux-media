Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1K20he-0006jH-HL
	for linux-dvb@linuxtv.org; Fri, 30 May 2008 11:15:16 +0200
From: Sigmund Augdal <sigmund@snap.tv>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <483EED5A.7080200@iki.fi>
References: <1212079844.26238.22.camel@rommel.snap.tv>
	<483EED5A.7080200@iki.fi>
Date: Fri, 30 May 2008 11:15:09 +0200
Message-Id: <1212138909.26238.34.camel@rommel.snap.tv>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Oops in tda10023
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

tor, 29.05.2008 kl. 20.52 +0300, skrev Antti Palosaari:
> Sigmund Augdal wrote:
> > using latest hg v4l-dvb on a 2.6.20 kernel.
> 
> I did some changes recently to tda10023 (needed for Anysee driver). I 
> wonder if these errors start coming after that? Those changes are 
> committed to master only few days ago, 05/26/2008.
When the crash happened I was using a module with these changes
included. This doesn't necessarily mean that these changes were the
cause of the problem. From reading the relevant diff I'd say it's quite
unlikely that your changes is causing the problem, as tda10023_writereg
was called from tda10023_attach before also, and you didn't change
anything in tda10023_writereg it self. I also know for a fact that the
i2c problems also did happen without your changes, so your changes isn't
the cause of that either.

About your changes to the tda10023 module, I tried these a while ago
(before they were merged into master, with a technotrend C-1501 board
that has a tda10023 demod with at tda8274a silicon tuner. I figured the
tuner had the same deltaf setting as the tuner used in anysee (based on
how this tuner is used in conjunction with tda10046), but I couldn't
figure out values for the pll_x parameters. I tried setting them to the
the same as the ones used in the anysee tree , but I couldn't get any
lock still, it may however be because my signal was bad at that point.
If I remember correctly your comments said something about an unknown
tuner used in the anysee device. Is there any chance it actually is the
tda827x? As this tuner-demod combo is sold as a refference design from
phillips.

Best Regards

Sigmund
> 
> regards
> Antti


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
