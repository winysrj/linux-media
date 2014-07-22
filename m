Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34155 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaGVOzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 10:55:52 -0400
Message-id: <53CE7B72.2030405@samsung.com>
Date: Tue, 22 Jul 2014 16:55:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"andrzej.p@samsung.com" <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] Documentation: devicetree: Document sclk-jpeg clock
 for exynos3250 SoC
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
 <14970063.d648TVkJj8@wuerfel> <53CE72B1.4080706@samsung.com>
 <7786783.sB22HqBgx3@wuerfel>
In-reply-to: <7786783.sB22HqBgx3@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/07/14 16:44, Arnd Bergmann wrote:
> I'd vote for listing it as an optional clock independent of the compatible
> string and changing the driver to just use it when it's provided.

That sounds good to me, thanks for the suggestion.

-- 
Regards,
Sylwester
