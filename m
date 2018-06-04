Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbeFDJ1O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 05:27:14 -0400
Subject: Re: [PATCH v2 1/9] xen/grant-table: Export gnttab_{alloc|free}_pages
 as GPL
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-2-andr2000@gmail.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <0c30e08a-a056-0123-601b-b1fd87faa46a@suse.com>
Date: Mon, 4 Jun 2018 11:27:10 +0200
MIME-Version: 1.0
In-Reply-To: <20180601114132.22596-2-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/18 13:41, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> 
> Only gnttab_{alloc|free}_pages are exported as EXPORT_SYMBOL
> while all the rest are exported as EXPORT_SYMBOL_GPL, thus
> effectively making it not possible for non-GPL driver modules
> to use grant table module. Export gnttab_{alloc|free}_pages as
> EXPORT_SYMBOL_GPL so all the exports are aligned.
> 
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
