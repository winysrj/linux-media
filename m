Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1K2EJv-0006lg-U4
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 01:47:44 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 31 May 2008 01:46:30 +0200
References: <482560EB.2000306@gmail.com>
In-Reply-To: <482560EB.2000306@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805310146.30798@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021 and
	stv0297
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

Hi,

I just wanted to commit this changeset when I spotted this:

e9hack wrote:
> @@ -266,6 +268,10 @@ static int tda10021_set_parameters (stru
>  
>         tda10021_setup_reg0 (state, reg0x00[qam], p->inversion);
>  
> +       /* reset uncorrected block counter */
> +       state->last_lock = 0;
> +       state->ucblocks = 0;

Note that UCB must count the number of uncorrected blocls during the
lifetime of the driver. So it must not be reset during tuning.
Agreed?

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
