Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:61376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0LVKw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 05:52:28 -0500
Message-ID: <4D11D864.4090904@redhat.com>
Date: Wed, 22 Dec 2010 08:52:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Halim Sahin <halim.sahin@freenet.de>
CC: linux-media@vger.kernel.org
Subject: Re: add Technisat skystar usb plus USB-ID
References: <20101205143116.GA1533@gentoo.local>
In-Reply-To: <20101205143116.GA1533@gentoo.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 05-12-2010 12:31, Halim Sahin escreveu:
> this device is a rebranded Technotrend s-2400 with USB id 0x3009.
> THx to Carsten Wehmeier for reporting
> 
> Signed-off-by: Halim Sahin <halim.sahin@freenet.de>
> 
> ---
> drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> index 192a40c..380066b 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> @@ -204,6 +204,7 @@
>  #define USB_PID_AVERMEDIA_A805				0xa805
>  #define USB_PID_AVERMEDIA_A815M				0x815a
>  #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
> +#define USB_PID_TECHNOTREND_CONNECT_S2400               0x3009
>  #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
> 

Just adding a new ID at dvb-usb-ids.h is the wrong thing to do. This will break
support for 0x3006 device. Instead, you should add a new definition, with a
different name, and duplicate the board entry at the driver that has support
for this device.

Thanks,
Mauro
