Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60603 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755800AbeFOGqu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 02:46:50 -0400
Subject: Re: [PATCH v4 5/9] xen/gntdev: Allow mappings for DMA buffers
To: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180615062753.9229-1-andr2000@gmail.com>
 <20180615062753.9229-6-andr2000@gmail.com>
 <e892748a-c268-9622-e568-4c361366bce1@epam.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <b9c3f740-dea1-638b-49d9-60cf5880619d@suse.com>
Date: Fri, 15 Jun 2018 08:46:46 +0200
MIME-Version: 1.0
In-Reply-To: <e892748a-c268-9622-e568-4c361366bce1@epam.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/06/18 08:32, Oleksandr Andrushchenko wrote:
> Please note, that this will need a change (attached) while
> applying to the mainline kernel because of API changes [1].
> 
> Unfortunately, current Xen tip kernel tree is v4.17-rc5 based,
> so I cannot make the change in this patch now.

I don't see any chance this series could go into 4.18, as the merge
window is just closing. So please post the patch based on current
Linux master of torvalds/linux.git


Juergen
