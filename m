Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:59418 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751279AbeDXMDX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:03:23 -0400
Subject: Re: [PATCH 2/3] media: ov5640: add PIXEL_RATE and LINK_FREQ controls
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com,
        mchehab@kernel.org
References: <20180420094419.11267-1-daniel@zonque.org>
 <20180420094419.11267-2-daniel@zonque.org>
 <20180424102222.ipzz754gou6kbdmk@valkosipuli.retiisi.org.uk>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <abb6fbed-c325-7ca5-09f0-74b3a989c3f1@zonque.org>
Date: Tue, 24 Apr 2018 14:03:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180424102222.ipzz754gou6kbdmk@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday, April 24, 2018 12:22 PM, Sakari Ailus wrote:
> On Fri, Apr 20, 2018 at 11:44:18AM +0200, Daniel Mack wrote:
>> Add v4l2 controls to report the pixel and MIPI link rates of each mode.
>> The camss camera subsystem needs them to set up the correct hardware
>> clocks.
>>
>> Tested on msm8016 based hardware.
>>
>> Signed-off-by: Daniel Mack <daniel@zonque.org>
> 
> Maxime has written a number of patches against the driver that seem very
> much related; could you rebase these on his set (v2)?
> 
> <URL:https://patchwork.linuxtv.org/project/linux-media/list/?submitter=Maxime+Ripard&state=*&q=ov5640>

I didn't know about the ongoing work in this area, so I think both this
and 3/3 are not needed. If you want, you can still pick the 1st patch in
this series, but that's just a cosmetic cleanup.


Thanks,
Daniel
