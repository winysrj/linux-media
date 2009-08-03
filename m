Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:12499 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZHCLnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2009 07:43:40 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1677390qwh.37
        for <linux-media@vger.kernel.org>; Mon, 03 Aug 2009 04:43:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A76CB7C.10401@gmail.com>
References: <200908031031.00676.marek.vasut@gmail.com>
	 <4A76CB7C.10401@gmail.com>
Date: Mon, 3 Aug 2009 17:13:40 +0530
Message-ID: <5d5443650908030443i3be3d4f9n3d4b69b2d8ce1631@mail.gmail.com>
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
From: Trilok Soni <soni.trilok@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Marek Vasut <marek.vasut@gmail.com>,
	video4linux-list@redhat.com,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eric,

On Mon, Aug 3, 2009 at 5:05 PM, Eric Miao<eric.y.miao@gmail.com> wrote:
> Marek Vasut wrote:
>> Hi!
>>
>> Eric, would you mind applying ?
>>
>> From 4dcbff010e996f4c6e5761b3c19f5d863ab51b39 Mon Sep 17 00:00:00 2001
>> From: Marek Vasut <marek.vasut@gmail.com>
>> Date: Mon, 3 Aug 2009 10:27:57 +0200
>> Subject: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
>>
>> Those formats are requiered on widely used OmniVision OV96xx cameras.
>> Those formats are nothing more then endian-swapped RGB555 and RGB565.
>>
>> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>
> Guennadi,
>
> Would be better if this gets merged by you, thanks.

linux-media is new list for v4l2.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
