Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:35343 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbbBMJND (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 04:13:03 -0500
Message-ID: <54DDC00D.209@xs4all.nl>
Date: Fri, 13 Feb 2015 10:12:45 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jurgen Kramer <gtmkramer@xs4all.nl>
CC: Raimonds Cicans <ray@apollo.lv>, linux-media@vger.kernel.org
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>		 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>		 <54CE24F2.7090400@apollo.lv> <54CF4508.9070305@xs4all.nl>	 <1423065972.2650.1.camel@xs4all.nl> <54D24685.1000708@xs4all.nl> <1423070484.2650.3.camel@xs4all.nl>
In-Reply-To: <1423070484.2650.3.camel@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jurgen,

On 02/04/2015 06:21 PM, Jurgen Kramer wrote:
> On Wed, 2015-02-04 at 17:19 +0100, Hans Verkuil wrote:
>> On 02/04/2015 05:06 PM, Jurgen Kramer wrote:
>>> Hi Hans,
>>>
>>> On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
>>>> Raimonds and Jurgen,
>>>>
>>>> Can you both test with the following patch applied to the driver:
>>>
>>> Unfortunately the mpeg error is not (completely) gone:
>>
>> OK, I suspected that might be the case. Is the UNBALANCED warning
>> gone with my vb2 patch?

>> When you see this risc error, does anything
>> break (broken up video) or crash, or does it just keep on streaming?

Can you comment on this question?

> 
> The UNBALANCED warnings have not reappeared (so far).

And they are still gone? If that's the case, then I'll merge the patch
fixing this for 3.20.

With respect to the risc error: the only reason I can think of is that it
is a race condition when the risc program is updated. I'll see if I can
spend some time on this today or on Monday. Can you give me an indication
how often you see this risc error message?

Regards,

	Hans
