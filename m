Return-path: <mchehab@pedra>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15487 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1CKUh7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 15:37:59 -0500
Date: Fri, 11 Mar 2011 12:37:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: David Cohen <dacohen@gmail.com>
Cc: Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, fernando.lugo@ti.com
Subject: Re: [PATCH v3 0/2] omap: iovmm: Fix IOVMM check for fixed 'da'
Message-ID: <20110311203757.GI10079@atomide.com>
References: <1299662253-29817-1-git-send-email-dacohen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299662253-29817-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* David Cohen <dacohen@gmail.com> [110309 01:16]:
> Hi,
> 
> Previous patch 2/3 was dropped in this new version. Patch 1 was updated
> according to a comment it got.
> 
> ---
> IOVMM driver checks input 'da == 0' when mapping address to determine whether
> user wants fixed 'da' or not. At the same time, it doesn't disallow address
> 0x0 to be used, what creates an ambiguous situation. This patch set moves
> fixed 'da' check to the input flags.

Applying these.

Tony
