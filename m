Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:18368 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZBFIBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2009 03:01:08 -0500
Received: by rv-out-0506.google.com with SMTP id k40so684812rvb.1
        for <linux-media@vger.kernel.org>; Fri, 06 Feb 2009 00:01:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902060012000.12903@axis700.grange>
References: <ur62u4qh5.wl%morimoto.kuninori@renesas.com>
	 <aec7e5c30901222024k3600b6b6t718998b945461a40@mail.gmail.com>
	 <Pine.LNX.4.64.0902060012000.12903@axis700.grange>
Date: Fri, 6 Feb 2009 17:01:06 +0900
Message-ID: <aec7e5c30902060001v6a1e59c6pe0c9f0a9a049660c@mail.gmail.com>
Subject: Re: [PATCH] sh_mobile_ceu_camera: NV12/21/16/61 are added only once.
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 6, 2009 at 8:21 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 23 Jan 2009, Magnus Damm wrote:
>> On Fri, Jan 23, 2009 at 9:28 AM, Kuninori Morimoto
>> <morimoto.kuninori@renesas.com> wrote:
>> > NV12/21/16/61 had been added every time
>> > UYVY/VYUY/YUYV/YVYU appears on get_formats.
>> > This patch modify this problem.
>>
>> That's one way to do it. Every similar driver has to do the same thing. Yuck.
>>
>> Or we could have a better translation framework that does OR for us,
>> using for instance bitmaps.
>
> This has been on my list for a while now, but I'm quite busy these days,
> but I think I now have an idea how to fix this problem in a less
> destructive way, withoug undermining the soc-camera algorithms:-) Please,
> have a look at the patch below. Does it fix the problem for you? If not -
> how can we modify it to work for you? Notice - not even completely compile
> tested:-)

Thanks for your effort on this. From a quick glance your solution is
fine with me, from the "fixing the bug" perspective at least. In
practice I don't think your solution is very different from
Morimoto-sans patch though. Maybe it's a bit cleaner.

But since the number of pixel formats are finite I still think a
bitmap would be useful to represent which formats that are supported.
Setting a bit in a bitmap is a much easier than walking lists to check
for duplicate modes.

OTOH, there are not that many drivers that need this format
translation at this point so the best may be just closing this issue
with and solve it in a more generic fashion later on if there are more
users.

Cheers,

/ magnus
