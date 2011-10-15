Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:60476 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1JOHfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 03:35:15 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9F7ZE4Z021238
	for <linux-media@vger.kernel.org>; Sat, 15 Oct 2011 03:35:14 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 4946F1E000D
	for <linux-media@vger.kernel.org>; Sat, 15 Oct 2011 03:35:13 -0400 (EDT)
Message-ID: <4E9937B1.5080806@lockie.ca>
Date: Sat, 15 Oct 2011 03:35:13 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: freeze/crash
References: <4E977989.30808@lockie.ca> <op.v3b9bll93xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net> <4E9881B6.8070606@lockie.ca> <op.v3c23z0s3xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
In-Reply-To: <op.v3c23z0s3xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/11 17:53, semiRocket wrote:
> On Fri, 14 Oct 2011 20:38:46 +0200, James <bjlockie@lockie.ca> wrote:
>
>> On 10/14/11 07:10, semiRocket wrote:
>> On Fri, 14 Oct 2011 01:51:37 +0200, James <bjlockie@lockie.ca> wrote:
>>  It always crashes when I access the hardware but the place it crashes
>> is random.
>>  Maybe you would want to pass those crash logs for debugging purposes 
>> What crash logs?
>> The kernel locks up, is there a log somewhere?
>
>
> System log under /var/log/messages
> or command dmesg
>
> Also, if you keep your terminal window open crash should pop-up by 
> itself so called "kernel oops". For example see first post in the 
> following link:
>     http://stackoverflow.com/questions/316131/how-do-you-diagnose-a-kernel-oops
There was no kernel oops, everything just froze.
dmesg seems to clear when I reboot.
