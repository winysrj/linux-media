Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Kpr5R-0001Fk-AX
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 23:05:52 +0200
Message-ID: <48F509A9.1030103@linuxtv.org>
Date: Tue, 14 Oct 2008 23:05:45 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Christophe Thommeret <hftom@free.fr>
References: <200810141133.36559.hftom@free.fr> <1985.1223980189@kewl.org>
	<200810141451.02941.hftom@free.fr>
In-Reply-To: <200810141451.02941.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx24116 DVB-S modulation fix
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

Christophe Thommeret wrote:
> dvbscan initial tuning data files for DVB-S don't have an entry for 
> modulation. So an app like kaffeine simply set modulation to QAM_AUTO.
> Why not QPSK, you ask? Simply because DVB-S standard allows QPSK and 16QAM. 
> Maybe there is not a single 16QAM TP all over the world, but it's still a 
> valid modulation for DVB-S.
> So, we set modulation to QAM_AUTO when it's unknown/unspecified, like in 
> dvbscan files (those being also used by kaffeine). And it works pretty well, 
> just because most dvb-s can only do QPSK and so force modulation to QPSK 
> instead of returning a notsup.
> See this as software QAM_AUTO :)

It simply doesn't make sense to specify QAM_AUTO if dvb_frontend_info.caps
doesn't contain FE_CAN_QAM_AUTO (or FE_CAN_QAM_16 for that matter).

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
