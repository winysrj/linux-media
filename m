Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <brett.maxfield@gmail.com>) id 1LWV1C-0006q9-QQ
	for linux-dvb@linuxtv.org; Mon, 09 Feb 2009 13:13:43 +0100
Received: by ti-out-0910.google.com with SMTP id j2so2069616tid.13
	for <linux-dvb@linuxtv.org>; Mon, 09 Feb 2009 04:13:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e021c7c00902090411j4df14a69me568a6022a5bc4d2@mail.gmail.com>
References: <e021c7c00902090411j4df14a69me568a6022a5bc4d2@mail.gmail.com>
Date: Mon, 9 Feb 2009 22:13:36 +1000
Message-ID: <e021c7c00902090413l12af9229t8a4db36f7c4ce160@mail.gmail.com>
From: Brett <brett.maxfield+linux-dvb@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dib0700 "buggy sfn workaround" or equivalent
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

Hello,

I have a dvb_usb_dib0700 (Nova 500 dual) card and it shows similar
issues to the dvb_usb_dib3000mc card, ie:

"This card has an issue (which particularly manifests itself in
Australia where a bandwidth of 7MHz is used) with jittery reception -
artifacts and choppy sound throughout recordings despite having full
signal strength. Australian users will typically see this behaviour on
SBS and ABC channels"

The fix for the dib3000mc is to enable the 'buggy sfn workaround' but
there is no such option for the dib 0700 :

The buggy sfn workaround workaround does "dib7000p_write_word(state,
166, 0x4000);" if it is active, or "dib7000p_write_word(state, 166,
0x0000)" if it inactive, in the dib3000mc driver. I presume this
tweaks a bandwidth filter or something similar for the dib3000mc, is
there  such an equivalent feature for the dib0700 chipset ?

Does anybody have specs on the dib0700 that describes registers, or
how to set tuner bandwidth etc., during tuning ?

Cheers
Brett

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
