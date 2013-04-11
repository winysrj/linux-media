Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:33378 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3DKUOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 16:14:48 -0400
Message-ID: <516719B3.8060502@gmail.com>
Date: Thu, 11 Apr 2013 22:14:43 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Barry Song <21cnbao@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	"renwei.wu" <renwei.wu@csr.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>, zilong.wu@csr.com,
	xiaomeng.hou@csr.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v8 1/7] media: V4L2: add temporary clock helpers
References: <CAGsJ_4zCRBvEX9xEDCr27JLK6wYp_2T_wk2hzVjqpKinbL=9pg@mail.gmail.com> <Pine.LNX.4.64.1304110921480.23859@axis700.grange> <CAGsJ_4xXRHDbpuqT3e5=0vz9_NxxCXfvrci+h567HP9=AhwRiQ@mail.gmail.com> <Pine.LNX.4.64.1304111028090.23859@axis700.grange> <CAGsJ_4yXE7SYLgPucW9kAEYgKg+z93j8yN3d+gvhqeLAn-sSOw@mail.gmail.com> <20130411185258.7915.67263@quantum>
In-Reply-To: <20130411185258.7915.67263@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/11/2013 08:52 PM, Mike Turquette wrote:
[...]
>>> So, you enable CFF, it provides its own clk_* implementation like
>>> clk_get_rate() etc. Now, PXA already has it defined in
>>> arch/arm/mach-pxa/clock.c. Don't think this is going to fly.
>>
>> agree.
>
> Hi,
>
> I came into this thread late and don't have the actual patches in my
> inbox for review.  That said, I don't understand why V4L2 cares about
> the clk framework *implementation*?  The clk.h api is the same for
> platforms using the common struct clk and those still using the legacy
> method of defining their own struct clk.  If drivers are only consumers
> of the clk.h api then the implementation underneath should not matter.

I came to similar conclusions previously, but in case when one of the two
drivers is the clock provider I think there is still an issue there.

The drivers are supposed to be platform agnostic, but the clock provider
would have to include mach specific declarations of struct clk, wouldn't
it ?

Regards,
Sylwester
