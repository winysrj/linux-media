Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1Jpxvq-0003p1-Bj
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 05:52:06 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: "Jan Louw" <myvonkpos@mweb.co.za>
Date: Sun, 27 Apr 2008 05:51:30 +0200
References: <20080412150444.987445669@gentoo.org>
	<200804121737.28314.zzam@gentoo.org>
	<000a01c8a7b7$5cc2c060$0500000a@Core2Duo>
In-Reply-To: <000a01c8a7b7$5cc2c060$0500000a@Core2Duo>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804270551.30966.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch 0/5] mt312: Add support for zl10313 demod
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

On Samstag, 26. April 2008, Jan Louw wrote:
> Hi Matthias,
>
> It still works. I combined your zl10313 modulator patch  with my earlier
> zl10039 frontend patch. The additional modifications necesary are in (see
> previous patch):
>
> ~/schwarzottv4l/v4l-dvb $ hg status
> M linux/drivers/media/dvb/frontends/Kconfig
> M linux/drivers/media/dvb/frontends/Makefile
> M linux/drivers/media/video/saa7134/Kconfig
> M linux/drivers/media/video/saa7134/saa7134-cards.c
> M linux/drivers/media/video/saa7134/saa7134-dvb.c
> M linux/drivers/media/video/saa7134/saa7134.h
> A linux/drivers/media/dvb/frontends/zl10039.c
> A linux/drivers/media/dvb/frontends/zl10039.h
> A linux/drivers/media/dvb/frontends/zl10039_priv.h
>
> To keep it simple I omitted the previous remote control code.
>

As you see here my zl10036 driver seems to work to some point:
http://thread.gmane.org/gmane.linux.drivers.dvb/41015/focus=41303

Could you please mail your current driver for zl10039.
Maybe it is worth merging both.

Regards
Matthias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
