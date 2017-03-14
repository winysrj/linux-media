Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:38648 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdCNLfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 07:35:47 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OMS0274JYVG1X80@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Mar 2017 20:35:40 +0900 (KST)
Subject: Re: [Patch v2 03/11] s5p-mfc: Use min scratch buffer size as provided
 by F/W
From: Smitha T Murthy <smitha.t@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org,
        pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-reply-to: <33a42a78-aaf8-5a57-c58c-62ebd37aa1ca@samsung.com>
Date: Tue, 14 Mar 2017 17:07:40 +0530
Message-id: <1489491460.27807.136.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090440epcas5p33f1bea986f2f9c961c93af94df7ec565@epcas5p3.samsung.com>
 <1488532036-13044-4-git-send-email-smitha.t@samsung.com>
 <33a42a78-aaf8-5a57-c58c-62ebd37aa1ca@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-03-06 at 15:18 +0100, Andrzej Hajda wrote: 
> On 03.03.2017 10:07, Smitha T Murthy wrote:
> > After MFC v8.0, mfc f/w lets the driver know how much scratch buffer
> > size is required for decoder. If mfc f/w has the functionality,
> > E_MIN_SCRATCH_BUFFER_SIZE, driver can know how much scratch buffer size
> > is required for encoder too.
> >
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> --
> Regards
> Andrzej
> 
Thank you for the review.
Regards
Smitha T Murthy 
> 
