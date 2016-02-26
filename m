Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34089 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbcBZNJ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 08:09:58 -0500
Subject: Re: [PATCH v5 0/8] Add MT8173 Video Encoder Driver and VPU Driver
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1456215081-16858-1-git-send-email-tiffany.lin@mediatek.com>
 <56CC1CAB.1060409@xs4all.nl> <56D03DE2.1090400@mm-sol.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D04E98.8040209@xs4all.nl>
Date: Fri, 26 Feb 2016 14:09:44 +0100
MIME-Version: 1.0
In-Reply-To: <56D03DE2.1090400@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2016 12:58 PM, Stanimir Varbanov wrote:
> Hi Hans,
> 
> <snip>
> 
>> Nice!
>>
>> Can you try 'v4l2-compliance -s'? Note that this may not work since I know
>> that v4l2-compliance doesn't work all that well with codecs, but I am
>> curious what the output is when you try streaming.
> 
> Sorry for the off topic question.
> 
> Does every new v4l2 encoder/decoder driver must use v4l2 mem2mem device
> framework, with other words is that mandatory?
> 

No, that's not mandatory. In most cases it will simplify your code, but
sometimes it only makes it harder and then you are better off doing it
yourself.

Regards,

	Hans
