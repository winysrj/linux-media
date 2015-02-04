Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:55860 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161559AbbBDTxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 14:53:55 -0500
Received: from mailo-proxy2.online.lv (smtp.online.lv [81.198.164.193])
	by fortimail.online.lv  with ESMTP id t14JrqOp004303-t14JrqOq004303
	for <linux-media@vger.kernel.org>; Wed, 4 Feb 2015 21:53:52 +0200
Message-ID: <54D278CF.9010605@apollo.lv>
Date: Wed, 04 Feb 2015 21:53:51 +0200
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Jurgen Kramer <gtmkramer@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>
	 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>
	 <54CE24F2.7090400@apollo.lv> <54CF4508.9070305@xs4all.nl>
 <1423065972.2650.1.camel@xs4all.nl> <54D24685.1000708@xs4all.nl>
In-Reply-To: <54D24685.1000708@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.02.2015 18:19, Hans Verkuil wrote:
> On 02/04/2015 05:06 PM, Jurgen Kramer wrote:
>> Hi Hans,
>>
>> On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
>>> Raimonds and Jurgen,
>>>
>>> Can you both test with the following patch applied to the driver:
> Raimond, do you still see the AMD iommu faults with this patch?

I have limited access to this box at workdays. I will try to test
your patch tomorrow.


Raimonds Cicans

