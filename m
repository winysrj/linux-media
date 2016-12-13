Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33662 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932984AbcLMKKy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 05:10:54 -0500
Subject: Re: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Nicholas Mc Guire <hofrat@osadl.org>
References: <1481594282-12801-1-git-send-email-hofrat@osadl.org>
 <20161213094346.GW16630@valkosipuli.retiisi.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <ce9f2ee0-c0d3-2eb4-a733-b108d12b43fb@gmail.com>
Date: Tue, 13 Dec 2016 10:10:51 +0000
MIME-Version: 1.0
In-Reply-To: <20161213094346.GW16630@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/12/16 09:43, Sakari Ailus wrote:
> Hi Nicholas,
>
> On Tue, Dec 13, 2016 at 02:58:02AM +0100, Nicholas Mc Guire wrote:
>> As this is not in atomic context and it does not seem like a critical
>> timing setting a range of 1ms allows the timer subsystem to optimize
>> the hrtimer here.
> I'd suggest not to. These delays are often directly visible to the user in
> use cases where attention is indeed paid to milliseconds.
>
> The same applies to register accesses. An delay of 0 to 100 µs isn't much as
> such, but when you multiply that with the number of accesses it begins to
> add up.
>
Data sheet for this device [1] says STBYN deassertion to RSTN 
deassertion should be >50us, though this is actually referenced to MCLK 
startup. See Figure 36, Power-Up Sequence, page 42.

I think the usleep range here could be greatly reduced and opened up to 
allow hr timer tweaks if desired.

[1] http://www.bdtic.com/DataSheet/SAMSUNG/S5K6AAFX13.pdf

Regards,
Ian
