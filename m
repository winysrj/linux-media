Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:24949 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755298AbdJIQpA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 12:45:00 -0400
Subject: Re: [PATCH v15 01/32] v4l: async: Remove re-probing support
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <d24f3e73-0eb5-f523-45a2-6d8b037b3a4d@samsung.com>
Date: Mon, 09 Oct 2017 18:44:52 +0200
MIME-version: 1.0
In-reply-to: <20171009141823.zu6m6ir2z7id7px3@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
        <20171004215051.13385-2-sakari.ailus@linux.intel.com>
        <20171009082239.189b4475@vento.lan>
        <20171009140646.vqftgwkttgn33m2t@valkosipuli.retiisi.org.uk>
        <67bcf879-f8dd-094e-47ba-3be977da02b2@xs4all.nl>
        <20171009141823.zu6m6ir2z7id7px3@valkosipuli.retiisi.org.uk>
        <CGME20171009164457epcas1p3c5e134e4bb5d85498fe8d4f00332f2fc@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/09/2017 04:18 PM, Sakari Ailus wrote:
> Sure, how about this at the end of the current commit message:
> 
> If there is a need to support removing the clock provider in the future,
> this should be implemented in the clock framework instead, not in V4L2.

I find it a little bit misleading, there is already support for removing
the clock provider, only any clock references for consumers became then
stale.  Perhaps:

"If there is a need to support the clock provider unregister/register 
cycle while keeping the clock references in the consumers in the future, 
this should be implemented in the clock framework instead, not in V4L2."

? That said, I doubt this issue is going to be entirely solved solely 
in the clock framework, as it is a more general problem of resource 
dependencies.  It could be related to other resources, like regulator
or GPIO.  It has been discussed for a long time now and it will likely 
take time until a general solution is available.

--
Thanks, 
Sylwester
