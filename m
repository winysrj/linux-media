Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49599 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751135AbdHXGul (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 02:50:41 -0400
Subject: Re: [PATCH] build: gpio_ir_tx needs 4.10 at least
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: d.scheller@gmx.net
References: <1503536501-20252-1-git-send-email-jasmin@anw.at>
 <d2750600-48a7-09cb-adb8-33d086e92e91@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3df53472-7da3-b82a-e051-df758669751e@xs4all.nl>
Date: Thu, 24 Aug 2017 08:50:37 +0200
MIME-Version: 1.0
In-Reply-To: <d2750600-48a7-09cb-adb8-33d086e92e91@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/2017 03:06 AM, Jasmin J. wrote:
> Hi!
> 
> With that patch (and the two before), the RC subsystem can be compiled again
> with older Kernels (I tested it with 3.13).

I've applied this one and the KEY_APPSELECT patch. The first should be fixed in
the kernel code, not in media_build.

Regards,

	Hans
