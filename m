Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36094 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750848AbdGGLz4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 07:55:56 -0400
Message-ID: <1499428551.5590.15.camel@linux.intel.com>
Subject: Re: [PATCH] staging: atomisp: replace kmalloc & memcpy with kmemdup
From: Alan Cox <alan@linux.intel.com>
To: Hari Prasath <gehariprasath@gmail.com>, mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, rvarsha016@gmail.com,
        julia.lawall@lip6.fr, singhalsimran0@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Jul 2017 12:55:51 +0100
In-Reply-To: <20170707115044.21744-1-gehariprasath@gmail.com>
References: <20170707115044.21744-1-gehariprasath@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-07-07 at 17:20 +0530, Hari Prasath wrote:
> kmemdup can be used to replace kmalloc followed by a memcpy.This was
> pointed out by the coccinelle tool.

And kstrdup could do the job even better I think ?

Alan
