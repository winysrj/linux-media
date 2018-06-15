Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48834 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753766AbeFOU6n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 16:58:43 -0400
Subject: Re: [PATCH v4 3/9] xen/balloon: Share common memory reservation
 routines
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
 <20180615062753.9229-4-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <0b7f2260-de99-56e2-b3d1-ee0a0bd88668@oracle.com>
Date: Fri, 15 Jun 2018 16:58:14 -0400
MIME-Version: 1.0
In-Reply-To: <20180615062753.9229-4-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2018 02:27 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> Memory {increase|decrease}_reservation and VA mappings update/reset
> code used in balloon driver can be made common, so other drivers can
> also re-use the same functionality without open-coding.
> Create a dedicated file for the shared code and export corresponding
> symbols for other kernel modules.
>
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
