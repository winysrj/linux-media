Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41617 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1EXPA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 11:00:58 -0400
Received: by eyx24 with SMTP id 24so2207316eyx.19
        for <linux-media@vger.kernel.org>; Tue, 24 May 2011 08:00:56 -0700 (PDT)
Message-ID: <4DDBC79A.5000302@mvista.com>
Date: Tue, 24 May 2011 18:58:34 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v18 5/6] davinci vpbe: Build infrastructure for VPBE driver
References: <1306245783-3483-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1306245783-3483-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Manjunath Hadli wrote:

> This patch adds the build infra-structure for Davinci
> VPBE dislay driver.

> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/davinci/Kconfig        |   23 +++++++++++++++++++++++
>  drivers/media/video/davinci/Makefile       |    2 ++
>  2 files changed, 25 insertions(+), 0 deletions(-)
>  delete mode 100644 drivers/staging/vme/bridges/Module.symvers
[...]

> diff --git a/drivers/staging/vme/bridges/Module.symvers b/drivers/staging/vme/bridges/Module.symvers
> deleted file mode 100644
> index e69de29..0000000

    Looks like a stray file got added to the patch...

WBR, Sergei

