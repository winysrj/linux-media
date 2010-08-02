Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44451 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HBKeA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 06:34:00 -0400
Date: Mon, 02 Aug 2010 12:32:20 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v3 1/8] ARM: Samsung: Add register definitions for Samsung
 S5P SoC camera interface
In-reply-to: <00ba01cb2c8f$02fc8480$08f58d80$%kim@samsung.com>
To: 'Kukjin Kim' <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org
Message-id: <003001cb322d$fc976b10$f5c64130$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1279902083-21250-1-git-send-email-s.nawrocki@samsung.com>
 <1279902083-21250-2-git-send-email-s.nawrocki@samsung.com>
 <00ba01cb2c8f$02fc8480$08f58d80$%kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

>Kukjin Kim <kgene.kim@samsung.com> wrote:
>Sylwester Nawrocki wrote:
>>
>> Add register definitions for the camera interface/video postprocessor
>> contained in Samsung's S5P SoC series.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
>> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  arch/arm/plat-samsung/include/plat/regs-fimc.h |  294
>> ++++++++++++++++++++++++
>>  1 files changed, 294 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/plat-samsung/include/plat/regs-fimc.h
>>
>> diff --git a/arch/arm/plat-samsung/include/plat/regs-fimc.h
>b/arch/arm/plat-
>> samsung/include/plat/regs-fimc.h
>> new file mode 100644
>> index 0000000..7f3141c
>> --- /dev/null
>> +++ b/arch/arm/plat-samsung/include/plat/regs-fimc.h
>> @@ -0,0 +1,294 @@
>> +/* arch/arm/plat-s5p/include/plat/regs-fimc.h
>> + *
>> + * Register definition file for Samsung Camera Interface (FIMC) driver

<snip>

>
>Looks ok...however, I'm still thinking whether really need all these
>definitions.
>
>Hmm...
>

Well, some of them are indeed unused, but it's not an uncommon practice in
kernel and might help future developers.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





