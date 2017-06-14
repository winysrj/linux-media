Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33597 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbdFNGsU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 02:48:20 -0400
Subject: Re: [PATCH v2 0/2] Avoid namespace collision within macros & tidyup
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        broonie@kernel.org, hverkuil@xs4all.nl, mattw@codeaurora.org,
        mitchelh@codeaurora.org, akpm@linux-foundation.org,
        yamada.masahiro@socionext.com
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, chris.paterson2@renesas.com
References: <20170613133348.48044-1-ramesh.shanmugasundaram@bp.renesas.com>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <293256b4-2477-e5f6-eca6-e5eaf9b14876@gmail.com>
Date: Wed, 14 Jun 2017 07:48:14 +0100
MIME-Version: 1.0
In-Reply-To: <20170613133348.48044-1-ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/06/17 14:33, Ramesh Shanmugasundaram wrote:
> Hi All,
> 
> The readx_poll_timeout & similar macros defines local variable that can
> cause name space collision with the caller. Fixed this issue by prefixing
> them with underscores.

The compound statement has a local variable scope, so these won't 
collide with the caller I believe.

> Also tidied couple of instances where the macro
> arguments are used in expressions without paranthesis.
> 
> This patchset is based on top of today's linux-next repo.
> commit bc4c75f41a1c ("Add linux-next specific files for 20170613")
> 
> Change history:
> 
> v2:
>   - iopoll.h:
> 	- Enclosed timeout_us & sleep_us arguments with paranthesis
>   - regmap.h:
> 	- Enclosed timeout_us & sleep_us arguments with paranthesis
> 	- Renamed pollret to __ret
> 
> Note: timeout_us cause spare check warning as identified here [1].
> 
> [1] https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg15138.html
> 
> Thanks,
> Ramesh
> 
> Ramesh Shanmugasundaram (2):
>    iopoll: Avoid namespace collision within macros & tidyup
>    regmap: Avoid namespace collision within macro & tidyup
> 
>   include/linux/iopoll.h | 12 +++++++-----
>   include/linux/regmap.h | 17 +++++++++--------
>   2 files changed, 16 insertions(+), 13 deletions(-)
> 
