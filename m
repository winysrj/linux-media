Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16133C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 17:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4FAA20685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 17:00:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="bYvuDzm1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbfAJRAQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 12:00:16 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:59410 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbfAJRAQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 12:00:16 -0500
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
        by smtprelay.synopsys.com (Postfix) with ESMTP id DF4F810C0A42;
        Thu, 10 Jan 2019 09:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1547139615; bh=AMdMSVG1Q7Xusu3VXK/+CposrKlkej3BAymwkHqU3FE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To:From;
        b=bYvuDzm1VbgZQZD3kpX6U+dq5MYkkG6ADK7a1CSnNVlhgCysfgC1aKYajCbMdP138
         YjVZGnzL1mpqc8jN8yVy72H0f06wOetCJb6ciFI1OHT4NyKlR6vseCSVStVXBLUmPs
         OqJHN3F60jODYaOXg2DJzpR04UwVy/0ydOZgfaakqDH/Oh36qAfkdmk+MyQxsRlAbI
         HlBd+jF2PIFaSNFhsNPxvJL4JF0pxmNf1HaROG1mNgjLTaQRIsC7/piRGS4dBFvMzY
         NVZhsE7Gya0xOJYYfU4911Tq1HX16FusOMIZeHuQQvpEQjO2uB9t4LOdyRj47Fxkvv
         k22OkFAi95cEw==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        by mailhost.synopsys.com (Postfix) with ESMTP id 16116560A;
        Thu, 10 Jan 2019 09:00:13 -0800 (PST)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 09:00:13 -0800
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 DE02WEHTCA.internal.synopsys.com (10.225.19.92) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 18:00:10 +0100
Received: from [10.107.19.13] (10.107.19.13) by
 DE02WEHTCB.internal.synopsys.com (10.225.19.80) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 18:00:10 +0100
Subject: Re: [V3, 4/4] media: platform: dwc: Add MIPI CSI-2 controller driver
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Luis Oliveira <luis.oliveira@synopsys.com>
CC:     <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joao.pinto@synopsys.com>, <festevam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Neil Armstrong" <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Thierry Reding <treding@nvidia.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Todor Tomov <todor.tomov@linaro.org>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
 <1798955.5kaMj8jiTI@avalon>
From:   Luis de Oliveira <luis.oliveira@synopsys.com>
Message-ID: <367bf8de-a70b-145a-a69a-9edfa8c635b4@synopsys.com>
Date:   Thu, 10 Jan 2019 17:00:07 +0000
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1798955.5kaMj8jiTI@avalon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.107.19.13]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Sorry for taking so long to answer. I was stuck in other projects and lost track
of this.

My answers inline,

On 14-Nov-18 20:22, Laurent Pinchart wrote:
> Hi Luis,
> 
> Thank you for the patch.
> 
> On Friday, 19 October 2018 15:52:26 EET Luis Oliveira wrote:
>> Add the Synopsys MIPI CSI-2 controller driver. This
>> controller driver is divided in platform dependent functions
>> and core functions. It also includes a platform for future
>> DesignWare drivers.
>>
>> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
>> ---
>> Changelog
>> v2-V3
>> - exposed IPI settings to userspace
> 
> Could you please explain why you need this and can't use standard APIs ? 
> Custom sysfs attributes are needed, they need to be documented in 
> Documentation/ABI/.
> 

IPI - Image Pixel Interface enables to access direct video stream in our CSI-2
Host IP and needs to be configured to match the video source. I can't hard code
it. But maybe I can think of a way to configure it using the video configuration.
I will try do that in the next patchset.

>> - fixed headers
>>
>>  MAINTAINERS                              |  11 +
>>  drivers/media/platform/dwc/Kconfig       |  30 +-
>>  drivers/media/platform/dwc/Makefile      |   2 +
>>  drivers/media/platform/dwc/dw-csi-plat.c | 699 ++++++++++++++++++++++++++++
>>  drivers/media/platform/dwc/dw-csi-plat.h |  77 ++++
>>  drivers/media/platform/dwc/dw-mipi-csi.c | 494 ++++++++++++++++++++++
>>  drivers/media/platform/dwc/dw-mipi-csi.h | 202 +++++++++
>>  include/media/dwc/dw-mipi-csi-pltfrm.h   | 102 +++++
>>  8 files changed, 1616 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/media/platform/dwc/dw-csi-plat.c
>>  create mode 100644 drivers/media/platform/dwc/dw-csi-plat.h
>>  create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.c
>>  create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.h
>>  create mode 100644 include/media/dwc/dw-mipi-csi-pltfrm.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index da2e509..fd5f1fc 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -14032,6 +14032,16 @@ S:	Maintained
>>  F:	drivers/dma/dwi-axi-dmac/
>>  F:	Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.txt
>>
>> +SYNOPSYS DESIGNWARE MIPI CSI-2 HOST VIDEO PLATFORM
>> +M:	Luis Oliveira <luis.oliveira@synopsys.com>
>> +L:	linux-media@vger.kernel.org
>> +T:	git git://linuxtv.org/media_tree.git
>> +S:	Maintained
>> +F:	drivers/media/platform/dwc
>> +F:	include/media/dwc/dw-mipi-csi-pltfrm.h
>> +F:	Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
>> +F:	Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
> 
> These two lines belong to patches 1/4 and 3/4. Doesn't checkpatch.pl warn 
> about this ? Now that I mentioned checkpatch.pl, I tried running it on this 
> series, and it generates a fair number of warnings and errors. Could you 
> please fix them ?
> 

I did, but maybe - or probably - i did not fix them all. Sorry.
I am preparing a new patchset and I will make sure everything goes right this time.

>> +
>>  SYNOPSYS DESIGNWARE DMAC DRIVER
>>  M:	Viresh Kumar <vireshk@kernel.org>
>>  R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> @@ -16217,3 +16227,4 @@ T:	git
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git S:	Buried
>> alive in reporters
>>  F:	*
>>  F:	*/
>> +
> 
> Stray new line.
> 
Noted.

> [snip]
> 
Thank you,
Luis
