Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:44495 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3CHKYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 05:24:12 -0500
Received: by mail-we0-f171.google.com with SMTP id u54so807010wey.30
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2013 02:24:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5139AFCA.6040409@ti.com>
References: <5139AFCA.6040409@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 8 Mar 2013 15:53:50 +0530
Message-ID: <CA+V-a8u0dGSY5b7yhFj+KsGZkAA_WCV2ThcVvNLK88O=MF9CXQ@mail.gmail.com>
Subject: Re: Error while building vpbe display as module
To: Sekhar Nori <nsekhar@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar,

On Fri, Mar 8, 2013 at 3:00 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> Prabhakar,
>
> Building with CONFIG_VIDEO_DAVINCI_VPBE_DISPLAY=m in latest mainline
> gives the error:
>
>    MODPOST 130 modules
> drivers/media/platform/davinci/vpbe_osd: struct platform_device_id is 24
> bytes.  The last of 3 is:
> 0x64 0x6d 0x33 0x35 0x35 0x2c 0x76 0x70 0x62 0x65 0x2d 0x6f 0x73 0x64
> 0x00 0x00 0x00 0x00 0x00 0x00 0x03 0x00 0x00 0x00
> FATAL: drivers/media/platform/davinci/vpbe_osd: struct
> platform_device_id is not  terminated with a NULL entry!
>
> Can you please look into this?
>
posted a patch(http://patchwork.linuxtv.org/patch/17159/) fixing the issue.

Regards,
--Prabhakar

> Thanks,
> Sekhar
