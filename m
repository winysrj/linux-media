Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34649 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754242AbcHSGDj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 02:03:39 -0400
Subject: Re: [PATCH v3 3/4] media: Add Mediatek MDP Driver
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
References: <1470751137-12403-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1470751137-12403-4-git-send-email-minghsiu.tsai@mediatek.com>
 <861e5c51-1333-fdc7-2793-d4741a48c72f@xs4all.nl>
 <1471586051.1540.11.camel@mtksdaap41>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2d18a4ee-69e6-e400-22b6-b3867b91b5c0@xs4all.nl>
Date: Fri, 19 Aug 2016 08:03:29 +0200
MIME-Version: 1.0
In-Reply-To: <1471586051.1540.11.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 07:54 AM, Minghsiu Tsai wrote:
> On Mon, 2016-08-15 at 14:55 +0200, Hans Verkuil wrote:
>> On 08/09/2016 03:58 PM, Minghsiu Tsai wrote:
>> This isn't right. For VIDEO_CAPTURE you support the COMPOSE targets, and for
>> the VIDEO_OUTPUT you support the CROP targets. Right now I can use e.g. TGT_CROP
>> with VIDEO_CAPTURE, which isn't correct.
>>
>> s_selection has the same problem.
>>
> 
> So my understanding is
> VIDEO_OUTPUT -> only allow to use target XXX_CROP_XXX
> VIDEO_CAPTURE -> only allow to use target XXX_COMPOSE_XXX
> 
> Am I right?

Correct.

Regards,

	Hans
