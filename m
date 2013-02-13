Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51088 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3BMXek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 18:34:40 -0500
Received: by mail-ea0-f174.google.com with SMTP id 1so653642eaa.33
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 15:34:38 -0800 (PST)
Message-ID: <511C230B.5060302@gmail.com>
Date: Thu, 14 Feb 2013 00:34:35 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"k.debski@samsung.com" <k.debski@samsung.com>,
	"kgene.kim@samsung.com" <kgene.kim@samsung.com>,
	"patches@linaro.org" <patches@linaro.org>,
	"inki.dae@samsung.com" <inki.dae@samsung.com>,
	"s.nawrocki@samsung.com" <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 1/2] [media] s5p-g2d: Add DT based discovery support
References: <1360128584-23167-1-git-send-email-sachin.kamat@linaro.org> <CAK9yfHzaDDD0XEywdv+P6gEapjHwxKEfwHzKKQuXWEPHeAFgCw@mail.gmail.com>
In-Reply-To: <CAK9yfHzaDDD0XEywdv+P6gEapjHwxKEfwHzKKQuXWEPHeAFgCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2013 06:30 PM, Sachin Kamat wrote:
>
> Hi Sylwester,
>
> On Wednesday, 6 February 2013, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>>  This patch adds device tree based discovery support to G2D driver
>>
>>  Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>  ---
>>  Based on for_v3.9 branch of below tree:
>>  git://linuxtv.org/snawrocki/samsung.git
>>
>>  Changes since v1:
>>  * Addressed review comments from Sylwester <s.nawrocki@samsung.com>.
>>  * Modified the compatible string as per the discussions at [1].
>>  [1] https://patchwork1.kernel.org/patch/2045821/
>>
>
> Does this patch look good?

It looks OK to me. I've sent a pull request including it, but it may
happen it ends up only in 3.10.

I tried to test this patch today and I had to correct some clock
definitions in the common clock API driver [1]. And we already have
quite a few fixes to that patch series.

Shouldn't you also provide a patch adding related OF_DEV_AUXDATA entry ?
How did you test this one ?

When the new clocks driver gets merged (I guess it happens only in 3.10)
I'd like to have the media devices' clock names cleaned up, instead of
names like: {"sclk_fimg2d", "fimg2d"}, {"sclk_fimc", "fimc"},
{"sclk_fimd"/"fimd"}, in clock-names property we could have common names,
e.g. { "sclk", "gate" }. This could simplify a bit subsystems like devfreq.

Also I noticed there are some issues caused by splitting mux + div + gate
clocks into 3 different clocks. One solution to this might be to use the
new composite clock type.

[1] http://www.spinics.net/lists/arm-kernel/msg214149.html
