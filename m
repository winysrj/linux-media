Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1K5Oic-0003Ui-Dt
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 19:30:15 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 8 Jun 2008 17:38:20 +0200
References: <1212585271.32385.41.camel@pascal>
	<1212590233.15236.11.camel@rommel.snap.tv>
	<1212657011.32385.53.camel@pascal>
In-Reply-To: <1212657011.32385.53.camel@pascal>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806081738.20609@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

Sigmund Augdal wrote:
> Here is a new version. This one passes checkpatch without warnings. I
> removed the read_pwm function, as it always uses the fallback path for
> my card (and frankly I have no idea wether it is actually relevant at
> all for this kind of card). Furthermore the tda10023 driver doesn't seem
> to use this value for anything.

Any issues with this patch? If not I will commit it next weekend.

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
