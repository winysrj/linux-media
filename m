Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2402 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3KDJd6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 04:33:58 -0500
Message-ID: <527769FA.9080207@xs4all.nl>
Date: Mon, 04 Nov 2013 10:33:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "edubezval@gmail.com" <edubezval@gmail.com>
CC: Dinesh Ram <dinesh.ram@cern.ch>,
	Linux-Media <linux-media@vger.kernel.org>,
	dinesh.ram086@gmail.com
Subject: Re: [Review Patch 0/9] si4713 usb device driver
References: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch> <CAC-25o8idLQUjQd9JK-n13bJdOH2riSakfP8GzMqXr=D8NV9CQ@mail.gmail.com>
In-Reply-To: <CAC-25o8idLQUjQd9JK-n13bJdOH2riSakfP8GzMqXr=D8NV9CQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/15/2013 07:37 PM, edubezval@gmail.com wrote:
> Hello Dinesh,
> 
> On Tue, Oct 15, 2013 at 11:24 AM, Dinesh Ram <dinesh.ram@cern.ch> wrote:
>> Hello Eduardo,
>>
>> In this patch series, I have addressed the comments by you
>> concerning my last patch series.
>> In the resulting patches, I have corrected most of the
>> style issues and adding of comments. However, some warnings
>> given out by checkpatch.pl (mostly complaing about lines longer
>> than 80 characters) are still there because I saw that code readibility
>> suffers by breaking up those lines.
>>
>> Also Hans has contributed patches 8 and 9 in this patch series
>> which address the issues of the handling of unknown regulators,
>> which have apparently changed since 3.10. Hans has tested it and the
>> driver loads again.
>>
>> Let me know when you are able to test it again.
>>
> 
> Hopefully I will be able to give it a shot on n900 and on silabs
> devboard until the end of the week. Thanks for not giving up.

Did you find time to do this? I'm waiting for feedback from you.

Regards,

	Hans
