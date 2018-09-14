Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57014 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbeINWa3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 18:30:29 -0400
Subject: Re: [PATCH v2 0/2] media: platform: Add Aspeed Video Engine Driver
To: Eddie James <eajames@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1536866964-71593-1-git-send-email-eajames@linux.vnet.ibm.com>
 <3fe3a367-5e63-446b-faba-fa6ac7a007cd@xs4all.nl>
 <1436d8d6-25ab-4bb8-5558-3e02fbe95e58@linux.vnet.ibm.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eff9f795-d28f-d9cd-ff04-752757856f94@xs4all.nl>
Date: Fri, 14 Sep 2018 19:14:58 +0200
MIME-Version: 1.0
In-Reply-To: <1436d8d6-25ab-4bb8-5558-3e02fbe95e58@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2018 05:08 PM, Eddie James wrote:
> 
> 
> On 09/14/2018 01:59 AM, Hans Verkuil wrote:
>> On 09/13/2018 09:29 PM, Eddie James wrote:
>>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>>> can capture and compress video data from digital or analog sources. With
>>> the Aspeed chip acting as a service processor, the Video Engine can
>>> capture the host processor graphics output.
>>>
>>> This series adds a V4L2 driver for the VE, providing a read() interface
>>> only. The driver triggers the hardware to capture the host graphics output
>>> and compress it to JPEG format.
>>>
>>>
>>> v4l2-compliance output:
>>>
>>> v4l2-compliance SHA   : not available
>> There should be a SHA here. "not available" indicates that you didn't compile
>> from the git repository directly, and now I do not know how old this compliance
>> test is. Always compile from the latest git repo, never use a version from e.g.
>> a distro as they tend to be old and missing tests.
>>
>> It would be great if you can do this and reply with the new compliance output.
> 
> Hmm, I did compile from the latest git repo (maybe a week old now), but 
> maybe our cross complication setup is preventing that hash from being 
> generated. Will try and get it.

You can also just report the git commit hash if you can't get it to work.
As long as I know from which source version it was built.

Regards,

	Hans
