Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:55129 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbbBFQC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2015 11:02:59 -0500
Received: from mailo-proxy2.online.lv (smtp.online.lv [81.198.164.193])
	by fortimail.online.lv  with ESMTP id t16G2p7i017726-t16G2p7k017726
	(version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 6 Feb 2015 18:02:51 +0200
Message-ID: <54D4E5AA.9050606@apollo.lv>
Date: Fri, 06 Feb 2015 18:02:50 +0200
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
 <54D278CF.9010605@apollo.lv>
In-Reply-To: <54D278CF.9010605@apollo.lv>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.02.2015 21:53, Raimonds Cicans wrote:
> On 04.02.2015 18:19, Hans Verkuil wrote:
>> On 02/04/2015 05:06 PM, Jurgen Kramer wrote:
>>> Hi Hans,
>>>
>>> On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
>>>> Raimonds and Jurgen,
>>>>
>>>> Can you both test with the following patch applied to the driver:
>> Raimond, do you still see the AMD iommu faults with this patch?
>
> I have limited access to this box at workdays. I will try to test
> your patch tomorrow.
>
>
Unfortunately I still see AMD iommu faults.

Test environment:
kernel: 3.18.1 (I was unable to compile drivers on kernel 3.13.10)
media tree: pure main media tree + your patch
test: 1) warm reboot
         2) run command "w_scan -fs -s S13E0 -D0c -a X"
             where X - receiver's number
             Tests were run on single receiver

Observations:
1) Tests were run three times on first receiver and three times on second.
     Only one test from three failed on first receiver.
     All tests failed on second receiver.

2) I have feeling that with your patch faults on first receiver appear 
less often
     but this may be pure luck or placebo.


Raimonds Cicans

