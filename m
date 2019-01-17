Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85DEC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 13:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A05C620855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 13:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfAQNBn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:01:43 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59147 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbfAQNBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 08:01:43 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud7.xs4all.net with ESMTPA
        id k7IggcZV3BDyIk7Ihg7dDU; Thu, 17 Jan 2019 14:01:42 +0100
Subject: Re: [PATCH] media: remove soc_camera ov9640
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Petr Cvek <petrcvekcz@gmail.com>
References: <cbb14a0b0a22202c17279155b17eca77aae05904.1547729848.git.mchehab+samsung@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c9c7e615-e6b6-eda7-ae44-8be8fd4ed7c7@xs4all.nl>
Date:   Thu, 17 Jan 2019 14:01:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <cbb14a0b0a22202c17279155b17eca77aae05904.1547729848.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBQqyjee+aJBP7IchmQvCV6Cg+732w6O/R8SO7mtwWfg/iBU8mkZ64gzn4AbGZnJ93hwCscsgLe3/nOPa/Pl8cnMnt6+L1RVUaUUTe0S8vCk3lkdQP9E
 cBoXnem/cAz9CkmPjsbermgmVDQIj7rhfELMHhQDz+d60vKTsvg0G/3mPf/vYmngDizIHO1G/irdI4GoOI2tTsk2vGt06wQtjGveUkIhyNAvKiKbhqs4ltYP
 PC+DZEmiy8LjlywyjTlewYvnq9UMpe+cKA5iIpE5mnoUxMPBG5LkmeYQpPI1t+PPB2K/ZoRmMPZiwI6kqfn5/8CiA8/hf4BI4xJmC+CvfIVOKfM/O8vaFynZ
 WMdikt978H4wUieO40siXN8KHUkfgm64ryuYxNCq+VsBSAM9z73jefD8yK6RNurduLEy1qgImDRnVzC7NXKVYoz3j6SSHr3nDwMFH6few1GaQ9yNiEI=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/17/19 1:57 PM, Mauro Carvalho Chehab wrote:
> This driver got converted to not depend on soc_camera on commit
> 57b0ad9ebe60 ("media: soc_camera: ov9640: move ov9640 out of soc_camera").
> 
> There's no sense on keeping the old version there.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans
