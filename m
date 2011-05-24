Return-path: <mchehab@pedra>
Received: from mailfe04.c2i.net ([212.247.154.98]:58471 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395Ab1EXQeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 12:34:25 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: =?iso-8859-1?q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
Subject: [RFC] drivers/media/dvb/dvb-usb/pctv452e.c does not work in latest media_tree.git
Date: Tue, 24 May 2011 18:33:09 +0200
Cc: Dominik Kuhlen <dkuhlen@gmx.net>,
	"Michael H. Schimek" <mschimek@gmx.at>,
	Juergen Lock <nox@jelal.kn-bremen.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <201105241432.16786.hselasky@c2i.net> <201105241542.31524.hselasky@c2i.net> <4DDBB9DD.7010804@web.de>
In-Reply-To: <4DDBB9DD.7010804@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105241833.09907.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 24 May 2011 15:59:57 André Weidemann wrote:
> Hi Peter,

> For the time being the S2-3200 and related cards do not seem to work.
>  From my understanding this patch should have been rolled back, but
> Mauro did not. Feel free to post a message to the linux-media mailing
> list. Maybe someone there knows a bit more...
> 
> Regards
>   André

Hi,

I did some more investigation and found what appears to be close to a fix:

media_tree/drivers/media/dvb/frontends/stb0899_algo.c

There is some automagic frequency guessing which does not work:

        /* timing loop computation & symbol rate optimisation   */
        derot_limit = (internal->sub_range / 2L) / internal->mclk;
        derot_step = (params->srate / 2L) / internal->mclk;
^^^^^ by changing this line to:
+        derot_step = (params->srate / 16L) / internal->mclk;

Things are starting to look better. I'm thinking about using a simple:

derot_freq = ((index * index) - index) * internal->direction;

This gives 127 steps before the maximum is reached.

        while ((stb0899_check_tmg(state) != TIMINGOK) && next_loop) {
                index++;
                derot_freq += index * internal->direction * derot_step; /* 
next derot zig zag position  */

                if (abs(derot_freq) > derot_limit)
                        next_loop--;

                if (next_loop) {
                        STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config-
>inversion * derot_freq));
                        STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config-
>inversion * derot_freq));
                        stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* 
derotator frequency         */
                }
                internal->direction = -internal->direction;     /* Change 
zigzag direction              */
        }

Any comments?

--HPS
