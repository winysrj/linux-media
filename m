Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1LTjcA-0002Mo-92
	for linux-dvb@linuxtv.org; Sun, 01 Feb 2009 22:12:28 +0100
Received: from pixle (pixle.cedo.cz [193.165.198.235])
	by postak.cedo.cz (Postfix) with SMTP id 5B0F6224EF8
	for <linux-dvb@linuxtv.org>; Sun,  1 Feb 2009 22:11:49 +0100 (CET)
Message-ID: <002d01c984b1$ab3820f0$217da8c0@tdrpc>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: <linux-dvb@linuxtv.org>
References: <20090131124351.169513hbsz3js5fk@neo.wg.de>
Date: Sun, 1 Feb 2009 22:11:37 +0100
MIME-Version: 1.0
Subject: Re: [linux-dvb] Technotrend C-2300 and CAM
Reply-To: linux-media@vger.kernel.org
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

> Hi,
>
> for some reason, my CAM (Alphacrypt Classic) doesn't seem to be
> detected by my Technotrend C-2300/CI combination. There is nothing in
> the kernel log/syslog when inserting or removing the card. I updated
> the card to the latest firmware (3.18) to no avail.
> I don't even know where to start debugging. No windows here, so I
> can't really tell whether this is a hardware problem.
> Any hints on where to start looking would help. The combination seems
> to work fine for almost everybody, beside one single thread on this
> list in 2007 that didn't come to a conclusion either.
>
> Jan.

Hi Jan, I have the same problem with my C-2300 card and TechniCrypt CX
(CAM). After several days of testing different kernels and drivers I tried
it somewhere in Windows and found that it's not working there as well. Maybe
some HW incompatibility... The CAM I have is the only one provided and
supported by my cable operator so I had to get another card. C-1501 is
functional for me and even cheaper.

Regards,
Tomas


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
