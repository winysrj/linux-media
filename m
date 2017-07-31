Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40270 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751794AbdGaHwi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 03:52:38 -0400
Subject: Re: [PATCH 8/8] omapdrm: hdmi4: hook up the HDMI CEC support
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-9-hverkuil@xs4all.nl>
 <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>
 <7d3ab159-9284-bcc8-80f0-cbc621769203@ti.com>
 <50af289e-2601-2d57-71ce-1d0a205277cb@xs4all.nl>
 <e88d84fa-b92e-1491-0c3b-d61d94b58234@ti.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c2764c8a-8206-8d1d-5422-134004cc21b5@xs4all.nl>
Date: Mon, 31 Jul 2017 09:52:33 +0200
MIME-Version: 1.0
In-Reply-To: <e88d84fa-b92e-1491-0c3b-d61d94b58234@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On 06/08/2017 11:19 AM, Tomi Valkeinen wrote:
> On 08/06/17 10:34, Hans Verkuil wrote:
> 
>>> Peter is about to send hotplug-interrupt-handling series, I think the
>>> HPD function work should be done on top of that, as otherwise it'll just
>>> conflict horribly.
>>
>> Has that been merged yet? And if so, what git repo/branch should I base
>> my next version of this patch series on? If not, do you know when it is
>> expected?
> 
> No, still pending review. The patches ("[PATCH v2 0/3] drm/omap: Support
> for hotplug detection") apply on top of latest drm-next, if you want to try.

I gather[1] that this has been merged? Where can I find a git tree that has
these patches? I'd like to get the omap4 CEC support in for 4.14.

Regards,

	Hans

[1]: http://www.spinics.net/lists/dri-devel/msg143440.html
