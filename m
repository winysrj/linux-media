Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754137AbeGBIUy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 04:20:54 -0400
Subject: Re: [PATCH v4 0/9] xen: dma-buf support for grant device
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        boris.ostrovsky@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        konrad.wilk@oracle.com, daniel.vetter@intel.com,
        dongwon.kim@intel.com, matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
 <0d314f2f-e0c1-1017-5ba9-83489038b544@gmail.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <ae597938-6d2a-9b4c-de7f-ec66429847bd@suse.com>
Date: Mon, 2 Jul 2018 10:20:52 +0200
MIME-Version: 1.0
In-Reply-To: <0d314f2f-e0c1-1017-5ba9-83489038b544@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/18 09:10, Oleksandr Andrushchenko wrote:
> Hello, Boris, Juergen!
> 
> Do you think I can re-base the series (which already has
> all required R-b's from Xen community) onto the latest kernel
> with API changes to patches 5 (of_dma_configure) and 8
> (dma-buf atomic ops) and we can merge it to the Xen's kernel tree?

Rebase: yes.

Merging to the Xen kernel tree: only after setting up the
for-linus-4.19 branch, which will be done by Boris later this
month.


Juergen
