Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1Jaw3O-0001Iv-0H
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 17:49:48 +0100
Message-ID: <47DD4FC1.8060707@philpem.me.uk>
Date: Sun, 16 Mar 2008 16:50:09 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <47DCFE62.6020405@philpem.me.uk>
	<1205677318.30122.14.camel@pc08.localdom.local>
In-Reply-To: <1205677318.30122.14.camel@pc08.localdom.local>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] CX88 (HVR-3000) -- strange errors in dmesg
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

hermann pitton wrote:
> looks like you need the last patches from Guennadi.
> http://marc.info/?l=linux-video&r=1&b=200803&w=2
> 
> Most important is that one in the middle.
> [PATCH] Fix left-overs from the videobuf-dma-sg.c conversion to generic
> DMA

Thanks - that seems to have fixed it.

Thanks,
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
