Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50559 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761990Ab2EQOxm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 10:53:42 -0400
Message-ID: <4FB510F5.4090902@iki.fi>
Date: Thu, 17 May 2012 17:53:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: pomidorabelisima@gmail.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] support for rtl2832
References: <1> <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.05.2012 01:13, Thomas Mair wrote:
> This is the new version of the patch series to add support for the
> rtl2832 demodulator driver. Before applying the patches you need to
> add the fc0012/fc0013 driver from Hans-Frider Vogt.

Who wants to review those tuner drivers?

> The changes from the privious version of the patches are manly in the
> rtl2832 demod driver to fix code style issues, a nasty bug in the
> frontends Makefile and the removal of the signal statistics functionality
> which was badly broken in version 0.3 of the driver.
>
> The one thing that I am not really confident with is the Kconfig file for
> the dvb frontend driver. Are the changes I made right? And if not what
> kind of changes need to be made?
>
> Thanks Antti and poma for your comments!


I have reviewed all patches and commented some issues. Those are after 
all relative small issues you can sent just new patch top of that to fix 
or rebase whole patch series and sent new. It is up to you.


regards
Antti

>
> Regards
> Thomas
>
> Thomas Mair (5):
>    rtl2832 ver. 0.4: removed signal statistics
>    rtl28xxu: support for the rtl2832 demod driver
>    rtl28xxu: renamed rtl2831_rd/rtl2831_wr to rtl28xx_rd/rtl28xx_wr
>    rtl28xxu: support G-Tek Electronics Group Lifeview LV5TDLX DVB-T
>    rtl28xxu: support Terratec Noxon DAB/DAB+ stick
>
>   drivers/media/dvb/dvb-usb/Kconfig          |    3 +
>   drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    3 +
>   drivers/media/dvb/dvb-usb/rtl28xxu.c       |  513 ++++++++++++++++--
>   drivers/media/dvb/frontends/Kconfig        |    7 +
>   drivers/media/dvb/frontends/Makefile       |    1 +
>   drivers/media/dvb/frontends/rtl2832.c      |  825 ++++++++++++++++++++++++++++
>   drivers/media/dvb/frontends/rtl2832.h      |   74 +++
>   drivers/media/dvb/frontends/rtl2832_priv.h |  258 +++++++++
>   8 files changed, 1636 insertions(+), 48 deletions(-)
>   create mode 100644 drivers/media/dvb/frontends/rtl2832.c
>   create mode 100644 drivers/media/dvb/frontends/rtl2832.h
>   create mode 100644 drivers/media/dvb/frontends/rtl2832_priv.h
>


-- 
http://palosaari.fi/
