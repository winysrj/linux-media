Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15973 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755076AbdCGMT3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 07:19:29 -0500
Subject: Re: [Patch v2 11/11] Documention: v4l: Documentation for HEVC CIDs
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <6c537c6a-0b87-0624-6770-73404972fb7a@samsung.com>
Date: Tue, 07 Mar 2017 13:08:19 +0100
MIME-version: 1.0
In-reply-to: <1488532036-13044-12-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090518epcas5p4d50e0bbaae69e93dc931c29ffaaa658b@epcas5p4.samsung.com>
 <1488532036-13044-12-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 03.03.2017 10:07, Smitha T Murthy wrote:
> Added V4l2 controls for HEVC encoder

It should be rather "Document controls for HEVC encoder" or sth similar.

In general most of comments are in previous patch.
Few additional comments:
- please be careful about control names - they are exported to userspace
and becomes ABI, so it will be difficult to change them later (this
comment is rather to previous patch),
- please provide good documentation as for most users this documentation
will be the only available source of information,
- in short: bugs in the driver can be easily fixed(usually), wrong
control names will be hard to fix, weak documentation will prevent using it.

And regarding this patch:
- please expand all acronyms (pb, tmv, BIT,...),
- please consider using menu instead of numbers for profile, level,
tier, types, generally everywhere where control value enumerates
'things' and is not a pure number (coefficient, counter,...),
- if control is per-frame please drop it, V4L2 does not support it at
the moment ( I suppose ),

Regards
Andrzej
