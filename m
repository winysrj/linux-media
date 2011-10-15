Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34116 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1JOLiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 07:38:19 -0400
Received: by eye27 with SMTP id 27so1796338eye.19
        for <linux-media@vger.kernel.org>; Sat, 15 Oct 2011 04:38:18 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-media Mailing List" <linux-media@vger.kernel.org>,
	James <bjlockie@lockie.ca>
Subject: Re: freeze/crash
References: <4E977989.30808@lockie.ca>
 <op.v3b9bll93xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
 <4E9881B6.8070606@lockie.ca>
 <op.v3c23z0s3xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
 <4E9937B1.5080806@lockie.ca>
Date: Sat, 15 Oct 2011 13:38:17 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: semiRocket <semirocket@gmail.com>
Message-ID: <op.v3d493g53xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
In-Reply-To: <4E9937B1.5080806@lockie.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Oct 2011 09:35:13 +0200, James <bjlockie@lockie.ca> wrote:

> On 10/14/11 17:53, semiRocket wrote:
>> On Fri, 14 Oct 2011 20:38:46 +0200, James <bjlockie@lockie.ca> wrote:
>>
>>> On 10/14/11 07:10, semiRocket wrote:
>>> On Fri, 14 Oct 2011 01:51:37 +0200, James <bjlockie@lockie.ca> wrote:
>>>  It always crashes when I access the hardware but the place it crashes
>>> is random.
>>>  Maybe you would want to pass those crash logs for debugging purposes  
>>> What crash logs?
>>> The kernel locks up, is there a log somewhere?
>>
>>
>> System log under /var/log/messages
>> or command dmesg
>>
>> Also, if you keep your terminal window open crash should pop-up by  
>> itself so called "kernel oops". For example see first post in the  
>> following link:
>>     http://stackoverflow.com/questions/316131/how-do-you-diagnose-a-kernel-oops
> There was no kernel oops, everything just froze.
> dmesg seems to clear when I reboot.

Yes, log is regenerated with reboot.

If everything just froze those pci slot swap seems like a good solution :)
It sounds to me like some hardware problem (maybe dust preventing a good  
contact in slot).
