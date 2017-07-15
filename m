Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.clear.net.nz ([203.97.37.64]:42962 "EHLO
        smtp4.clear.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdGOUwq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 16:52:46 -0400
Received: from mxin3-orange.clear.net.nz
 (lb1-srcnat.clear.net.nz [203.97.32.236])
 by smtp4.clear.net.nz (CLEAR Net Mail)
 with ESMTP id <0OT5003ALFXJX720@smtp4.clear.net.nz> for
 linux-media@vger.kernel.org; Sun, 16 Jul 2017 08:37:09 +1200 (NZST)
Date: Sun, 16 Jul 2017 08:37:05 +1200
From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
In-reply-to: <20170709194221.10255-1-d.scheller.oss@gmail.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Message-id: <962a5ae5-60bc-22bd-534d-fe05705322b4@clear.net.nz>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
>
> Preferrably for Linux 4.14 (to get things done).
>
> Hard-depends on the STV0910/STV6111 driver patchset as the diff and the
> updated code depends on the driver and the changes involved with the
> glue code of the STV/DDCineS2V7 series [1].
>
> Mauro/Media maintainers, this updates drivers/media/pci/ddbridge to the
> very latest code that DD carry in their vendor driver package as of
> version 0.9.29, in the "once, the big-bang-way is ok" way as discussed at
> [2] (compared to the incremental, awkward to do variant since that
> involves dissecting all available release archives and having to - try
> to - build proper commits out of this, which will always be inaccurate;
> a start was done at [3], however - and please understand - I definitely
> don't want to continue doing that...)

-snip

Posting another "tested by" for this patch series, in conjunction with 
the recently posted STV0910/STV6111 set that I've been testing longer term

Have been running this series, since it was posted here, several hours 
daily on a dedicated vdr based PVR with a Digital Devices Cine S2 V7A, 
kernel 4.12 and vdr 2.3.8.

MSI interrupts are enabled and no issues to date.

Thanks to Daniel and the reviewers.

Regards,

Richard
