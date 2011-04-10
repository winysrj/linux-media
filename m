Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:47862 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab1DJM2d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 08:28:33 -0400
Message-ID: <4DA1A26F.2010305@linuxtv.org>
Date: Sun, 10 Apr 2011 14:28:31 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Speed up DVB TS stream delivery from DMA buffer into
 dvb-core's buffer
References: <4D9F2C83.6070401@kolumbus.fi> <4D9F63E1.6060808@kolumbus.fi>
In-Reply-To: <4D9F63E1.6060808@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/08/2011 09:37 PM, Marko Ristola wrote:
> 
> Here is some statistics without likely and with likely functions.
> 
> It seems that using likely() gives better performance with Phenom I too.

I'm not sure whether that's the right conclusion. See below.

> 	%	Plain knl %	No likely	%	With likely	%
> dvb_ringbuffer_write		5,9	62,8	8,7	81,3	5,7	79,2
> dvb_dmx_swfilter_packet	1,2	12,8	0,7	6,5	0,8	11,1
> dvb_dmx_swfilter_204		2,3	24,5	1,3	12,1	0,7	9,7
> 
> 
> Here "Plain knl %" is "perf top -d 30" percentage.
> 24,5 12,1 and 9,7 are percentages without a patch, with basic patch
> and last is with "likely" functions using patch.

The varying ratio between dvb_ringbuffer_write and
dvb_dmx_swfilter_packet, which haven't been modified by the patch, seems
to indicate that the numbers were influenced by other activities on the
system or by the data used during the tests. 8,7% for
dvb_ringbuffer_write in test #2 could also indicate a higher data rate
than in #1 and #3.

However, adding likely() certainly won't do any harm. Feel free to send
an incremental patch.

Regards,
Andreas
