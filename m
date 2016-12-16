Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36309 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759657AbcLPMeS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 07:34:18 -0500
Subject: Re: [PATCH 2/2] media: omap3isp change to devm for resources
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1481829721.git.shuahkh@osg.samsung.com>
 <98a3d1794bc001f312a7db31ad03465ba697bb36.1481829722.git.shuahkh@osg.samsung.com>
 <56d66910-1776-26a5-53fc-20e44fea490b@xs4all.nl> <2253735.S1P71dP0gH@avalon>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ed8c09dd-a198-7dca-3b44-624ff7f1ff5c@xs4all.nl>
Date: Fri, 16 Dec 2016 13:34:04 +0100
MIME-Version: 1.0
In-Reply-To: <2253735.S1P71dP0gH@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/12/16 13:19, Laurent Pinchart wrote:
> Hi Hans,
>
> On Friday 16 Dec 2016 12:39:49 Hans Verkuil wrote:
>> On 15/12/16 20:40, Shuah Khan wrote:
>>> Using devm resources that have external dependencies such as a dev
>>> for a file handler could result in devm resources getting released
>>> durin unbind while an application has the file open holding pointer
>>> to the devm resource. This results in use-after-free errors when the
>>> application exits.
>>
>> That's solving the wrong problem.
>>
>> The real problem is that when registering a video_device it should do
>> this:
>>
>> devnode->cdev.kobj.parent = &devnode->dev.kobj;
>>
>> (taken from cec-core.c)
>>
>> This will prevent isp->dev from being released as long as there is a
>> filehandle still open.
>
> But it won't be enough, devm_* resources are released at unbind time, not at
> device release time. Right after the unbind (.remove() for platform devices)
> handler returns, devm_kzalloc allocated memory goes away.

You're completely right, I keep forgetting about that.

Sorry for the noise.

	Hans

>
>> After that change I believe that this will work correctly, but this
>> has to be tested first!
>

