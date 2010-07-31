Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58233 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0GaPtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 11:49:32 -0400
Received: by iwn7 with SMTP id 7so2424416iwn.19
        for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 08:49:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimahhDfTESneHAGNe-lCRDr4Pw8a_dJ_tp0a2F5@mail.gmail.com>
References: <AANLkTimahhDfTESneHAGNe-lCRDr4Pw8a_dJ_tp0a2F5@mail.gmail.com>
Date: Sat, 31 Jul 2010 08:49:31 -0700
Message-ID: <AANLkTi=wmDpP1UV0Do7NZfB8zLZW2+jTjoquZ0Qx3toU@mail.gmail.com>
Subject: Re: [PATCH] Fix module dependency selection for Mantis driver
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Cc: Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 11, 2010 at 8:11 PM, VDR User <user.vdr@gmail.com> wrote:
> This patch adds missing module dependencies to the Mantis Kconfig file
> so that they are selected automatically when the user enables Mantis.
>
> Signed-off-by: Derek Kelly <user.vdr@gmail.com>
> ----------
>
> --- v4l-dvb.orig/linux/drivers/media/dvb/mantis/Kconfig 2010-06-11
> 14:28:26.000000000 -0700
> +++ v4l-dvb/linux/drivers/media/dvb/mantis/Kconfig      2010-06-11
> 14:32:44.000000000 -0700
> @@ -10,6 +10,8 @@ config MANTIS_CORE
>  config DVB_MANTIS
>        tristate "MANTIS based cards"
>        depends on MANTIS_CORE && DVB_CORE && PCI && I2C
> +       select DVB_STB0899
> +       select DVB_STB6100
>        select DVB_MB86A16
>        select DVB_ZL10353
>        select DVB_STV0299
>

Any reason this was ignored?
