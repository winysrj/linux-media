Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.ispdone.com ([69.39.47.46] helo=smtp-auth0.ispdone.com)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <purevw@wtxs.net>) id 1MNpc4-0001hD-Ls
	for linux-dvb@linuxtv.org; Mon, 06 Jul 2009 16:56:13 +0200
Received: from [192.168.1.110] (net-69-39-58-26.texascom.net [69.39.58.26]
	(may be forged)) (authenticated bits=0)
	by smtp-auth0.ispdone.com (8.13.1/8.13.1) with ESMTP id n66EtZBG007070
	for <linux-dvb@linuxtv.org>; Mon, 6 Jul 2009 09:55:36 -0500
From: Ronnie Bailey <purevw@wtxs.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.1.1246874401.8966.linux-dvb@linuxtv.org>
References: <mailman.1.1246874401.8966.linux-dvb@linuxtv.org>
Date: Mon, 06 Jul 2009 09:55:34 -0500
Message-Id: <1246892134.5898.9.camel@Opto>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Status of em28xx support
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

Mike,
	The answer to your question is "yes". I own an ATI HD USB receiver with
an empia chipset. It works well, with the only problem being a conflict
of some kind with Compiz. I simply disable desktop effects when I want
to watch TV. 
	You can find the info you need at linuxtv.org as far as getting and
installing the driver is concerned. Be aware that there are multiple
versions of the needed firmware. The firmware at the site may not be the
exact firmware that you need. What I did was to extract the firmware
from the Windows driver for my specific receiver and copy it to
the /lib/firmware/ directory. 
	After installing V4L-DVB and plugging in your card, run "dmesg" and
look for any errors. If there is a firmware issue, you should see it
there. If Devin is still monitoring this site, he may step in and offer
help. He gave me an incredible amount of help and is very familiar with
the card I have.


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
