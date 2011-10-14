Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:53068 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab1JNSit (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 14:38:49 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9EIclQp025454
	for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 14:38:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 5BF7D1E000D
	for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 14:38:46 -0400 (EDT)
Message-ID: <4E9881B6.8070606@lockie.ca>
Date: Fri, 14 Oct 2011 14:38:46 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: freeze/crash
References: <4E977989.30808@lockie.ca> <op.v3b9bll93xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
In-Reply-To: <op.v3b9bll93xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/11 07:10, semiRocket wrote:
> On Fri, 14 Oct 2011 01:51:37 +0200, James <bjlockie@lockie.ca> wrote:
>
>> It always crashes when I access the hardware but the place it crashes
>> is random.
>
> Maybe you would want to pass those crash logs for debugging purposes :)
What crash logs?
The kernel locks up, is there a log somewhere?
>
> It's possible for developers to track from them where the crash occurs
> in driver.

It occurred to me to try the mythbuntu livedvd. :-)

That didn't work so I tried my other PCIe slot (I had to disconnect 
stuff to make it fit :-() and it works now.

