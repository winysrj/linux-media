Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47025 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030449Ab2ERXkD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 19:40:03 -0400
Received: by wibhj8 with SMTP id hj8so601053wib.1
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 16:40:02 -0700 (PDT)
Message-ID: <4FB6DDCF.1000204@gmail.com>
Date: Sat, 19 May 2012 01:39:59 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v5 0/5] support for rtl2832
References: <1> <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/18/2012 08:47 PM, Thomas Mair wrote:
> Good Evening!
> 
> This is the corrected version of the patch series to support the 
> RTL2832 demodulator. There where no major changes. The majority of
> the changes consist in fixing style issues and adhering to proper
> naming conventions.
> 
> The next question for me is how to proceed when including new
> devices. Poma already sent an extensive list a little while 
> ago (http://patchwork.linuxtv.org/patch/10982/). Should they
> all be included at once, or should I wait until somone confirms 
> they are working correctly and include them one by one?
> 
> Regards 
> Thomas
> 
> Thomas Mair (5):
>   rtl2832 ver. 0.5: support for RTL2832 demod
>   rtl28xxu: support for the rtl2832 demod driver
>   rtl28xxu: renamed rtl2831_rd/rtl2831_wr to rtl28xx_rd/rtl28xx_wr
>   rtl28xxu: support Delock USB 2.0 DVB-T
>   rtl28xxu: support Terratec Noxon DAB/DAB+ stick
> 
>  drivers/media/dvb/dvb-usb/Kconfig          |    3 +
>  drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    3 +
>  drivers/media/dvb/dvb-usb/rtl28xxu.c       |  516 ++++++++++++++++--
>  drivers/media/dvb/frontends/Kconfig        |    7 +
>  drivers/media/dvb/frontends/Makefile       |    1 +
>  drivers/media/dvb/frontends/rtl2832.c      |  823 ++++++++++++++++++++++++++++
>  drivers/media/dvb/frontends/rtl2832.h      |   74 +++
>  drivers/media/dvb/frontends/rtl2832_priv.h |  260 +++++++++
>  8 files changed, 1638 insertions(+), 49 deletions(-)
>  create mode 100644 drivers/media/dvb/frontends/rtl2832.c
>  create mode 100644 drivers/media/dvb/frontends/rtl2832.h
>  create mode 100644 drivers/media/dvb/frontends/rtl2832_priv.h
> 

Compliment!

regards,
poma
