Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50123 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752309AbeF0GXp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 02:23:45 -0400
Subject: Re: V4L2_CID_USER_MAX217X_BASE == V4L2_CID_USER_IMX_BASE
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Helmut Grohne <h.grohne@intenta.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
References: <20180622075151.g24iiqfcg5pwbr73@laureti-dev>
 <0b2e6f14-3297-fc53-5af0-2494ac6c925f@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4618c951-1be5-c553-9108-b15c53c57b60@xs4all.nl>
Date: Wed, 27 Jun 2018 08:23:38 +0200
MIME-Version: 1.0
In-Reply-To: <0b2e6f14-3297-fc53-5af0-2494ac6c925f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/26/2018 11:21 PM, Steve Longerbeam wrote:
> Hello Helmut,
> 
> 
> On 06/22/2018 12:51 AM, Helmut Grohne wrote:
>> Hi,
>>
>> I found it strange that the macros V4L2_CID_USER_MAX217X_BASE and
>> V4L2_CID_USER_IMX_BASE have equal value even though each of them state
>> that they reserved a range. Those reservations look conflicting to me.
> 
> Yes, they conflict.
> 
>> The macro V4L2_CID_USER_MAX217X_BASE came first,
> 
> No, imx came first. e1302912 ("media: Add i.MX media core driver")
> is dated June 10, 2017. 8d67ae25 ("media: v4l2-ctrls: Reserve controls for
> MAX217X") is dated two days later.
> 
>>   and
>> V4L2_CID_USER_IMX_BASE was introduced in e130291212df ("media: Add i.MX
>> media core driver") with the conflicting assignment (not a merge error).
>> The authors of that patch mostly make up the recipient list.
> 
> There were 8 revisions of the imx-media driver posted. In all of
> those postings, V4L2_CID_USER_MAX217X_BASE did not exist yet.
> So it looks like 8d67ae25 was merged at the same time as e1302912
> but the conflict went unnoticed.
> 
> Steve
> 

Since imx is staging I propose that the IMX base is modified. Steve, can
you make a patch for this changing 0x1090 to 0x10b0?

Regards,

	Hans
