Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1K8hD8-0001i0-6j
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 21:51:22 +0200
Received: by py-out-1112.google.com with SMTP id a29so2114673pyi.0
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 12:51:17 -0700 (PDT)
Message-Id: <2A4C3A00-C39D-4BB7-BFA1-B099F2B1BDBE@tvwhere.com>
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: mkrufky@linuxtv.org
In-Reply-To: <48580F4F.2010301@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Tue, 17 Jun 2008 15:51:13 -0400
References: <48580F4F.2010301@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 or tveeprom - Missing dependency? [SOLVED?]
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


On Jun 17, 2008, at 3:23 PM, mkrufky@linuxtv.org wrote:

> The cx18 driver DOES NOT require tuner-simple.  It is the HVR1600 that
> requires the tuner-simple module, for analog tuner mode only.  Thus,
> when a user selects VIDEO_CX18, the default behavior is for  
> TUNER_SIMPLE
> to also get selected.

Last one - selecting VIDEO_CX18 does not select TUNER_SIMPLE. That is  
what I have been asking to be enabled.

Brandon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
