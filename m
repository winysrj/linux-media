Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49633 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab1KQKgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:36:45 -0500
Received: by bke11 with SMTP id 11so1790664bke.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 02:36:44 -0800 (PST)
Message-ID: <4EC4E385.7030101@mvista.com>
Date: Thu, 17 Nov 2011 14:35:49 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/5] ARM: davinci: create new common platform header
 for davinci
References: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com> <1321525138-3928-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321525138-3928-5-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 17-11-2011 14:18, Manjunath Hadli wrote:

> remove the code from individual platform header files for
> dm365, dm355, dm644x and dm646x and consolidate it into a
> single and common header file davinci_common.h.
> Include the new header file in individual platform header
> files as a pre-cursor for deleting these headers in follow
> up patches.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>

    Sorry, didn't notice something in the first review...

> diff --git a/arch/arm/mach-davinci/include/mach/davinci.h b/arch/arm/mach-davinci/include/mach/davinci.h
> new file mode 100644
> index 0000000..49bf2f3
> --- /dev/null
> +++ b/arch/arm/mach-davinci/include/mach/davinci.h
> @@ -0,0 +1,88 @@
> +/*
> + * This file contains the processor specific definitions
> + * of the TI DM644x, DM355, DM365, and DM646X.

    DM646x for consistency.

> +/* DM644X function declarations */

    DM644x for consistency.

> +/* DM646X function declarations */

    DM646x for consistency.

WBR, Sergei
