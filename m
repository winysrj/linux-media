Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:34318 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbaJFRky (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Oct 2014 13:40:54 -0400
Date: Mon, 6 Oct 2014 19:40:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	iss_storagedev@hp.com, linux-edac@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/7 linux-next] drivers: remove deprecated IRQF_DISABLED
Message-ID: <20141006174050.GA20739@pd.tnic>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412609755-28627-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 06, 2014 at 05:35:47PM +0200, Fabian Frederick wrote:
> This small patchset removes IRQF_DISABLED from drivers branch.
> 
> See include/linux/interrupt.h:
> "This flag is a NOOP and scheduled to be removed"
> 
> Note: (cross)compiled but untested.
> 
> Fabian Frederick (7):
>   mv64x60_edac: remove deprecated IRQF_DISABLED
>   ppc4xx_edac: remove deprecated IRQF_DISABLED

For the EDAC bits already applied Michael's patch:

https://lkml.kernel.org/r/1412159043-7348-1-git-send-email-michael.opdenacker@free-electrons.com

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
