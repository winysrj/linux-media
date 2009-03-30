Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55786 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZC3PUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 11:20:11 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"psp_video@list.ti.com - Video discussion list for PSP Video team (May
	contain non-TIers)" <psp_video@list.ti.com>
Date: Mon, 30 Mar 2009 20:49:54 +0530
Subject: RE: BT656 Support and MMDC support on top of OMAP3EVM
Message-ID: <19F8576C6E063C45BE387C64729E73940427E3F72D@dbde02.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E73940427CBFCEE@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940427CBFCEE@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Thursday, March 19, 2009 5:57 PM
> To: linux-media@vger.kernel.org
> Cc: linux-omap@vger.kernel.org; psp_video@list.ti.com - Video
> discussion list for PSP Video team (May contain non-TIers)
> Subject: [PSP_VIDEO] BT656 Support and MMDC support on top of
> OMAP3EVM
> 
> Hi,
> 
> I am getting some private requests for supporting BT656 and Multi-
> Media Daughter card on top of latest Kernel + Sakari's latest ISP-
> Camera patches/repository. So I am posting the patch supporting
> BT656 and MMDC support with all the review comments fixed (received
> from earlier posts).
> 
> Please note that, hence forth I will try to avoid submitting patches
> on top of V4L2-int framework. The next immediate activity would be
> migration to sub-device framework.
> 
> Sakari,
> 
> How about merging these patches (BT656 support patch) into your
> repository so that I don't have to maintain and re-submit the
> patches again and again.
> 
[Hiremath, Vaibhav] Sakari,

I have not heard back anything from you on this, if you don't see any issues then I request you to merge these patches into your private branch/repository. So that people will be able to use it directly.

> If you feel it should be done, then please let me know if you have
> any review comments I will try to fix immediately and provide you a
> patch.
> 
> The patches are following this mail.
> 
> Thanks,
> Vaibhav Hiremath

