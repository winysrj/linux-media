Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1K5Oid-0003Uu-0u
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 19:30:16 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 8 Jun 2008 17:43:33 +0200
References: <20080607184758.GA30074@halim.local>
	<200806080029.00312@orion.escape-edv.de>
	<20080608084217.GA15568@halim.local>
In-Reply-To: <20080608084217.GA15568@halim.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806081743.33402@orion.escape-edv.de>
Subject: Re: [linux-dvb] budget_av,  high cpuload with kncone tvstar
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

Halim Sahin wrote:
> Hi Oliver,
> Thanks a lot thats it.
> I have on emore Question:
> dmesg says ci interface initialized but this card has not a ci
> connector.
> Is there a way to disable ci support completely?

No, unless you comment-out the ciint_init call.
Is this a problem?

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
