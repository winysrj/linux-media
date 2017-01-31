Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45811 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdAaJi3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 04:38:29 -0500
Subject: Re: [PATCH] [media] s5p-mfc: Align stream buffer and CPB buffer to 512
From: Smitha T Murthy <smitha.t@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org,
        pankaj.dubey@samsung.com, krzk@kernel.org, m.szyprowski@samsung.com
In-reply-to: <de7bbdbf-35cc-a575-79d1-2ec5764469a5@samsung.com>
Content-type: text/plain; charset=UTF-8
Date: Tue, 31 Jan 2017 14:42:33 +0530
Message-id: <1485853953.16927.23.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
References: <CGME20170118094212epcas5p22e588016d2b330dcd0b99b6e1012c744@epcas5p2.samsung.com>
 <1484732223-24670-1-git-send-email-smitha.t@samsung.com>
 <de7bbdbf-35cc-a575-79d1-2ec5764469a5@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-01-18 at 15:37 +0100, Andrzej Hajda wrote: 
> Hi Smitha,
> 
> On 18.01.2017 10:37, Smitha T Murthy wrote:
> > >From MFCv6 onwards encoder stream buffer and decoder CPB buffer
> 
> Unexpected char at the beginning.
> 
> > need to be aligned with 512.
> 
> Patch below adds checks only if buffer size is multiple of 512, am I right?
> If yes, please precise the subject, for example "...CPB buffer size need
> to be...".
> 

Thank you for the review, after further analysis I found this patch is
not required. So I will drop it. 

