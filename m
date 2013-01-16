Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51264 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3APPPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 10:15:32 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGQ00GNM51IWV70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jan 2013 15:15:31 +0000 (GMT)
Received: from AVDC146 ([106.116.59.211])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MGQ00LT851QBG30@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jan 2013 15:15:30 +0000 (GMT)
From: Radoslaw Moszczynski <r.moszczynsk@samsung.com>
To: 'Antti Palosaari' <crope@iki.fi>
Cc: linux-media@vger.kernel.org
References: <016601cdf3f1$9e7925e0$db6b71a0$%moszczynsk@samsung.com>
 <50F6BB14.40302@iki.fi>
In-reply-to: <50F6BB14.40302@iki.fi>
Subject: RE: PcTV Nanostick 290e -- DVB-C frontend only working after
 reconnecting the device
Date: Wed, 16 Jan 2013 16:15:24 +0100
Message-id: <016701cdf3fc$4efe28c0$ecfa7a40$%moszczynsk@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With Ubuntu's 3.5 kernel, the DVB-C frontend is not registered at all --
only DVB-T/T2 is available.

I'll do some more testing with newer/older kernels over the next few days.

Regards-
  -Radek

-----Original Message-----
From: Antti Palosaari [mailto:crope@iki.fi] 
Sent: Wednesday, January 16, 2013 3:37 PM
To: Radoslaw Moszczynski
Cc: linux-media@vger.kernel.org
Subject: Re: PcTV Nanostick 290e -- DVB-C frontend only working after
reconnecting the device

On 01/16/2013 03:58 PM, Radoslaw Moszczynski wrote:
> Hi,
>
> I'm not sure if this has been already reported, but I was playing 
> around with Nanostick 290e today and I encountered some weird behavior 
> with the DVB-C frontend.
>
> The DVB-C frontend only seems to work once after plugging in the device.
> During subsequent uses, it fails to lock on to signal. However, you 
> can unplug the Nanostick, plug it back in, and it is able to lock on 
> again. But only once -- then you have to replug it again.
>
> The exact actions that I took:
>
> 1. Plug in the Nanostick.
> 2. Run dvbstream to record a DVB-C stream -- works OK.
> 3. Run dvbstream to record a DVB-C stream again -- fail to lock on signal.
> 4. Unplug the Nanostick. Plug it back in.
> 5. Run dvbstream to record a DVB-C stream -- works OK.
> 6. Run dvbstream to record a DVB-C stream again -- fail to lock on signal.
>
> I'm using kernel 3.2.0 on Ubuntu x86. The DVB-T/T2 frontend doesn't 
> display this behavior.
>
> If anyone's interested in debugging this, I'll be happy to provide 
> more information.

Could you test first quite latest Kernel, 3.7 or even 3.8. If 3.7 behaves
similarly, then test older Kernel 3.0.

Working only on first tuning attempt sounds like it should not be common
problem - otherwise there should be million bug reports like that.

regards
Antti

--
http://palosaari.fi/


