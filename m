Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:59272 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbcHBREG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 13:04:06 -0400
Date: Tue, 2 Aug 2016 13:53:05 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Baole Ni <baolex.ni@intel.com>
Cc: mchehab@kernel.org, andrey.utkin@corp.bluecherry.net, bp@alien8.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, jh1009.sung@samsung.com,
	nenggun.kim@samsung.com, hdegoede@redhat.com
Subject: Re: [PATCH 0505/1285] Replace numeric parameter like 0444 with macro
Message-ID: <20160802165304.dbok2ekhijtdbqqp@pirotess.bf.iodev.co.uk>
References: <20160802111854.15621-1-baolex.ni@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160802111854.15621-1-baolex.ni@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/Ago/2016 19:18, Baole Ni wrote:
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permission.
> As we know, these numeric value for access permission have had the corresponding macro,
> and that using macro can improve the robustness and readability of the code,
> thus, I suggest replacing the numeric parameter with the macro.

That's very subjective; I don't agree.

IMO numbers are better in this context.
