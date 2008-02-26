Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JTtz3-0008Ax-0W
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 08:12:13 +0100
Message-ID: <47C3BBD8.3050007@philpem.me.uk>
Date: Tue, 26 Feb 2008 07:12:24 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Christophe Boyanique <tof+linux-dvb@raceme.org>
References: <47A98F3D.9070306@raceme.org> <47C3161F.4020802@raceme.org>
In-Reply-To: <47C3161F.4020802@raceme.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

Christophe Boyanique wrote:
> options dvb-usb-dib0700 force_lna_activation=1
> options dvb_usb disable_rc_polling=1

Did that last night and I'm still seeing MT2060 I2C timeouts... *sigh*

This is on Mythbuntu 8.04 alpha-2, latest updates, running drivers from Hg TIP 
patched for the HVR-3000 (using the dev.kewl.org multi-frontend patch).

Thanks,
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
