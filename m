Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1JUDcX-0002lE-Mt
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 05:10:17 +0100
Message-ID: <47C4E2B6.40900@linuxtv.org>
Date: Wed, 27 Feb 2008 05:10:30 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Peter Hartley <pdh@utter.chaos.org.uk>
References: <1204046724.994.21.camel@amd64.pyotr.org>
In-Reply-To: <1204046724.994.21.camel@amd64.pyotr.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two streams
 from same mux
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

Peter Hartley wrote:
> The attached patch adds a new value for dmx_output_t:
> DMX_OUT_TSDEMUX_TAP, which sends TS to the demux0 device. The main
> question I have, is, seeing as this was such a simple change, why didn't
> it already work like that? Does everyone else who wants to capture
> multiple video streams, take the whole multiplex into userspace and
> demux it themselves? Or do they take PES from each demux0 device and
> re-multiplex that into PS, not TS?

I like your patch and would like to ask Mauro to integrate it if no one
objects, mainly because it serves as a basis for a DMX_ADD_PID ioctl
suggested by Felix Domke some months ago.

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
