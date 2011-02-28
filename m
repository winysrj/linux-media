Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39802 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1B1PsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 10:48:02 -0500
Message-ID: <4D6BC3AE.903@suse.cz>
Date: Mon, 28 Feb 2011 16:47:58 +0100
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH v2 -resend#1 1/1] V4L: videobuf, don't use dma addr as
 physical
References: <1298885822-10083-1-git-send-email-jslaby@suse.cz> <20110228145301.GC10846@dumpdata.com>
In-Reply-To: <20110228145301.GC10846@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/28/2011 03:53 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Feb 28, 2011 at 10:37:02AM +0100, Jiri Slaby wrote:
>> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
>> needn't be a physical address in presence of IOMMU. So ensure we are
> 
> Can you add a comment why you are fixing it? Is there a bug report for this?
> Under what conditions did you expose this fault?

No, by a just peer review when I was looking for something completely
different.

> You also might want to mention that "needn't be a physical address as
> a hardware IOMMU can (and most likely) will return a bus address where
> physical != bus address."

Mauro, do you want me to resend this with such an udpate in the changelog?

> Otherwise you can stick 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
> on it.

thanks,
-- 
js
suse labs
