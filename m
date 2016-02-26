Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:55962 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbcBZL6b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 06:58:31 -0500
Subject: Re: [PATCH v5 0/8] Add MT8173 Video Encoder Driver and VPU Driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1456215081-16858-1-git-send-email-tiffany.lin@mediatek.com>
 <56CC1CAB.1060409@xs4all.nl>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
From: Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <56D03DE2.1090400@mm-sol.com>
Date: Fri, 26 Feb 2016 13:58:26 +0200
MIME-Version: 1.0
In-Reply-To: <56CC1CAB.1060409@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

<snip>

> Nice!
> 
> Can you try 'v4l2-compliance -s'? Note that this may not work since I know
> that v4l2-compliance doesn't work all that well with codecs, but I am
> curious what the output is when you try streaming.

Sorry for the off topic question.

Does every new v4l2 encoder/decoder driver must use v4l2 mem2mem device
framework, with other words is that mandatory?

-- 
regards,
Stan
