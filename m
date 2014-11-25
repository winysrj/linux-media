Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaKYIho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 03:37:44 -0500
Message-ID: <54743FB9.7070601@redhat.com>
Date: Tue, 25 Nov 2014 09:37:13 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com> <1416498928-1300-4-git-send-email-hdegoede@redhat.com> <20141121084933.GL24143@lukather> <546F0226.2040700@redhat.com> <20141124220327.GS4752@lukather> <54743DE1.7020704@redhat.com>
In-Reply-To: <54743DE1.7020704@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/25/2014 09:29 AM, Hans de Goede wrote:

<snip>

> Well one reasons why clocks are instantiated the way they are is to have
> them available as early as possible, which is really convenient and works
> really well.
>
> You are asking for a whole lot of stuff to be changed, arguably in a way
> which makes it worse, just to save 47 lines of code...

Thinking more about this one alternative which should work is to just put the
clocks in the prcm in the clocks node, then they get their own reg property,
rather then being part of the prcm reg range, and the standard of_clk mod0
driver we have will just work.

Regards,

Hans

