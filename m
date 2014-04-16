Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:41482 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbaDPPeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 11:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <1397583272-28295-5-git-send-email-s.nawrocki@samsung.com>
References: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
	<1397583272-28295-5-git-send-email-s.nawrocki@samsung.com>
Date: Wed, 16 Apr 2014 10:34:36 -0500
Message-ID: <CAL_Jsq+VRGpVZwFs1QwCz6YY8WmPUO7ZJtWQ3kVY8p1jWe0LGg@mail.gmail.com>
Subject: Re: [PATCH 4/5] exynos4-is: Remove requirement for "simple-bus" compatible
From: Rob Herring <robherring2@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 15, 2014 at 12:34 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> This patch makes the driver instantiating its child devices itself,
> rather than relying on an OS to instantiate devices as children
> of "simple-bus". This removes an incorrect usage of "simple-bus"
> compatible.

Good, but why can't you use of_platform_populate with the root being
the "samsung,fimc" node? The code to instantiate the devices belongs
in the core OF code.

Rob
