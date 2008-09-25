Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KinJs-000284-ST
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 11:39:33 +0200
Date: Thu, 25 Sep 2008 11:38:55 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Chris Rankin <rankincj@yahoo.com>
In-Reply-To: <902525.49080.qm@web52908.mail.re2.yahoo.com>
Message-ID: <alpine.LRH.1.10.0809251137000.1247@pub1.ifh.de>
References: <902525.49080.qm@web52908.mail.re2.yahoo.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge DVB USB2 Nova-TD stick - report.
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

On Tue, 23 Sep 2008, Chris Rankin wrote:

> I was surprised to see it reported as product 0x5200 because I bought a 
> Nova-T device several years ago which was product 0x9301.

Why are you surprised? Because the number is not consecutive ?

> My Nova-TD device comes with a remote control, but no event node was 
> created for it until I hacked the following lines into 
> dib0700_devices.c:
>                .rc_interval      = DEFAULT_RC_INTERVAL,
>                .rc_key_map       = dib0700_rc_keys,
>                .rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
>                .rc_query         = dib0700_rc_query

Can you please create a patch of that modification against the v4l-dvb 
mercurial tree? Then I can easily apply it.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
