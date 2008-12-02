Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.10])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1L7aom-0002hs-T0
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 20:21:59 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Tue, 2 Dec 2008 20:21:48 +0100
References: <99503.50867.qm@web88302.mail.re4.yahoo.com>
	<a3ef07920812020937jb0feff7q695f91dbd2156b5e@mail.gmail.com>
	<007801c954b1$29b4d030$0000fea9@cr344472a>
In-Reply-To: <007801c954b1$29b4d030$0000fea9@cr344472a>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812022021.49856.zzam@gentoo.org>
Subject: Re: [linux-dvb] [FIXEd] Bug Report - Twinhan vp-1020,
	bt_8xx driver + frontend
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

On Dienstag, 2. Dezember 2008, Alain Turbide wrote:
> Well, it's not a difficult fix now that I see it.  The issue was that the
> original default for FE_ALGO_SW was 0 while FE_ALGO_HW was 1.
> Since there is an older documented option for the dst module called
> dst_algo that some people might still be using to force the tuning algo to
> sofware by setting dst_algo=0, there is no choice but to also make the
> default of DVBFE_ALGO_SW to also be 0 so that the values will match and the
> new code will still function with users who force dst_algo=0 on the dst
> module load.. The fix would thus be to go from: this in dvb_frontend.h
> enum dvbfe_algo {
>         DVBFE_ALGO_HW                   = (1 <<  0),
>         DVBFE_ALGO_SW                   = (1 << 1),
>         DVBFE_ALGO_CUSTOM               = (1 <<  2),
>         DVBFE_ALGO_RECOVERY             = (1 << 31)
> };
>
> to this:
> enum dvbfe_algo {
>         DVBFE_ALGO_HW                   = (1 <<  0),
>         DVBFE_ALGO_SW                   = 0,
>         DVBFE_ALGO_CUSTOM               = (1 <<  2),
>         DVBFE_ALGO_RECOVERY             = (1 << 31)
> };
>
> This is what I've done now and works well. This is the only change required
> to fix the issue.   In dst.c we could also default dst_algo to
> DVB_FRONTEND_SW instead of 0 to make it more robust.  I can't see any code
> else where that depends on DVBFE_ALGO_SW being set to 2.
>

Why should we rely on exact values, and not just modify the only place where 
these values are exposed to userspace, and change dst_get_tuning_algo to 
something similar to:

static int dst_get_tuning_algo(struct dvb_frontend *fe)
{
        return dst_algo ? DVBFE_ALGO_HW : DVBFE_ALGO_SW;
}

The other (not backward compatible) fix is to adjust the parameter description 
and use 1 and 2 as allowed settings.

Regards
Matthias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
