Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63264 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab2HKTcS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 15:32:18 -0400
Message-ID: <5026B33F.3030605@gmail.com>
Date: Sat, 11 Aug 2012 21:32:15 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	oselas@community.pengutronix.de,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 0/1] S3C244X/S3C64XX SoC camera host interface driver
References: <50269F15.4030504@gmail.com> <9609498.7r78ladCdh@flatron>
In-Reply-To: <9609498.7r78ladCdh@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2012 08:39 PM, Tomasz Figa wrote:
> Hi,
> 
> On Saturday 11 of August 2012 20:06:13 Sylwester Nawrocki wrote:
>> Hi all,
>>
>> This patch adds a driver for Samsung S3C244X/S3C64XX SoC series camera
>> host interface. My intention was to create a V4L2 driver that would work
>> with standard applications like Gstreamer or mplayer, and yet exposing
>> possibly all features available in the hardware.
>>
>> It took me several weeks to do this work in my (limited) spare time.
>> Finally I've got something that is functional and I think might be useful
>> for others, so I'm publishing this initial version. It hopefully doesn't
>> need much tweaking or corrections, at least as far as S3C244X is
>> concerned. It has not been tested on S3C64XX SoCs, as I don't have the
>> hardware. However, the driver has been designed with covering S3C64XX as
>> well in mind, and I've already taken care of some differences between
>> S3C2444X and S3C64XX. Mem-to-mem features are not yet supported, but
>> these are quite separate issue and could be easily added as a next step.
> 
> I will try to test it on S3C6410 in some reasonably near future and report
> any needed corrections.

Sounds great, thanks.

> Currently I am using a modified s5p-fimc driver in my project, but it
> supports only the codec path of S3C64xx and any needed stream duplication
> and rescaling is done in later processing, so it might be wise to migrate
> to yours.

Yeah, the s3c camif is quite different from the s5p one. Thus the s3c-camif
driver might be a much better starting point for S3C6410. I could test any
changes for s3c6410 back on s3c2440 and incorporate the verified ones into 
some common stable git branch.

--

Regards,
Sylwester 
