Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC92EC43387
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 21:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 964F320815
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 21:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfACVoL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 16:44:11 -0500
Received: from xes-mad.com ([162.248.234.2]:26598 "EHLO mail.xes-mad.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfACVoL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 16:44:11 -0500
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2019 16:44:10 EST
Received: from zimbra.xes-mad.com (zimbra.xes-mad.com [10.52.0.127])
        by mail.xes-mad.com (Postfix) with ESMTP id 5421B201EC;
        Thu,  3 Jan 2019 15:33:20 -0600 (CST)
Date:   Thu, 3 Jan 2019 15:33:20 -0600 (CST)
From:   Aaron Sierra <asierra@xes-inc.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     mchehab@kernel.org, iommu <iommu@lists.linux-foundation.org>,
        hans verkuil <hans.verkuil@cisco.com>,
        bingbu cao <bingbu.cao@intel.com>,
        rajmohan mani <rajmohan.mani@intel.com>,
        yong zhi <yong.zhi@intel.com>,
        tian shu qiu <tian.shu.qiu@intel.com>,
        linux-media@vger.kernel.org
Message-ID: <1276926960.401168.1546551200268.JavaMail.zimbra@xes-inc.com>
In-Reply-To: <20190103201126.zzqpn2eylm4m2zxn@mara.localdomain>
References: <20190102211657.13192-1-sakari.ailus@linux.intel.com> <12009133.IFJkWA3Ofo@avalon> <20190103201126.zzqpn2eylm4m2zxn@mara.localdomain>
Subject: Re: [PATCH 1/1] iova: Allow compiling the library without IOMMU
        support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.0.127]
X-Mailer: Zimbra 8.7.5_GA_1764 (ZimbraWebClient - FF64 (Linux)/8.7.5_GA_1764)
Thread-Topic: iova: Allow compiling the library without IOMMU support
Thread-Index: CxgTQemcdkLrN3bN00VVx7sfIidDEA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

----- Original Message -----
> From: "Sakari Ailus" <sakari.ailus@linux.intel.com>
> Sent: Thursday, January 3, 2019 2:11:27 PM

Hi Laurent and Sakari,

I don't have much else to offer here, but wanted to second Sakari's
use case below.

> Hi Laurent,
> 
> On Thu, Jan 03, 2019 at 12:52:00AM +0200, Laurent Pinchart wrote:
>> Hi Sakari,
>> 
>> Thank you for the patch.
>> 
>> On Wednesday, 2 January 2019 23:16:57 EET Sakari Ailus wrote:
>> > Drivers such as the Intel IPU3 ImgU driver use the IOVA library to manage
>> > the device's own virtual address space while not implementing the IOMMU
>> > API.
>> 
>> Why is that ? Could the IPU3 IOMMU be implemented as an IOMMU driver ?
> 
> You could do that, but:
> 
> - it's a single PCI device so there's no advantage in doing so and

I also use the IOVA library for a PCI device (PCIe-VME bridge) that has
IOMMU features, but isn't a general purpose IOMMU. I am eagerly following
along.

-Aaron

> - doing that would render the device inoperable if an IOMMU is enabled in
>  the system, as chaining IOMMUs is not supported in the IOMMU framework
>  AFAIK.
> 
>> 
>> > Currently the IOVA library is only compiled if the IOMMU support is
>> > enabled, resulting into a failure during linking due to missing symbols.
>> > 
>> > Fix this by defining IOVA library Kconfig bits independently of IOMMU
>> > support configuration, and descending to the iommu directory
>> > unconditionally during the build.
>> > 
>> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
