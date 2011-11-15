Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50748 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1KOKEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 05:04:10 -0500
Received: by fagn18 with SMTP id n18so181964fag.19
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2011 02:04:08 -0800 (PST)
Message-ID: <4EC238E2.3040600@mvista.com>
Date: Tue, 15 Nov 2011 14:03:14 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/5] davinci: create new common platform header for
 davinci
References: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com> <1321283357-27698-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321283357-27698-5-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 14-11-2011 19:09, Manjunath Hadli wrote:

> remove the code from individual platform header files for
> dm365, dm355, dm644x and dm646x and consolidate it into a
> single and common header file davinci_common.h.
> Include the new header file in individual platform header
> files as a pre-cursor for deleting these headers in follow
> up patches.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> ---
>   .../arm/mach-davinci/include/mach/davinci_common.h |   88 ++++++++++++++++++++
>   arch/arm/mach-davinci/include/mach/dm355.h         |   18 +----
>   arch/arm/mach-davinci/include/mach/dm365.h         |   20 +----
>   arch/arm/mach-davinci/include/mach/dm644x.h        |   15 +---
>   arch/arm/mach-davinci/include/mach/dm646x.h        |   20 +----
>   5 files changed, 92 insertions(+), 69 deletions(-)
>   create mode 100644 arch/arm/mach-davinci/include/mach/davinci_common.h

> diff --git a/arch/arm/mach-davinci/include/mach/davinci_common.h b/arch/arm/mach-davinci/include/mach/davinci_common.h
> new file mode 100644
> index 0000000..a859318
> --- /dev/null
> +++ b/arch/arm/mach-davinci/include/mach/davinci_common.h

    Why not call it just davinci.h?

WBR, Sergei
