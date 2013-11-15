Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57224 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3KOTRY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 14:17:24 -0500
Message-ID: <52867341.7050500@iki.fi>
Date: Fri, 15 Nov 2013 21:17:21 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
References: <1384103776-4788-1-git-send-email-crope@iki.fi>	<5280D83C.5060809@xs4all.nl>	<5280DE3D.5040408@iki.fi>	<528671DF.7040707@iki.fi> <CAGoCfiz8EBqkEUuzYLXhgXGW-0S6+6s3MAFWdSpfFmuOnP+Dfg@mail.gmail.com>
In-Reply-To: <CAGoCfiz8EBqkEUuzYLXhgXGW-0S6+6s3MAFWdSpfFmuOnP+Dfg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.11.2013 21:13, Devin Heitmueller wrote:
> On Fri, Nov 15, 2013 at 2:11 PM, Antti Palosaari <crope@iki.fi> wrote:
>> When I do it inside Kernel, in URB completion handler at the same time when
>> copying data to videobuf2, using pre-calculated LUTs and using mmap it eats
>> 0.5% CPU to transfer stream to app.
>>
>> When I do same but using libv4lconvert as that patch, it takes ~11% CPU.
>
> How are you measuring?  Interrupt handlers typically don't count
> toward the CPU performance counters.  It's possible that the cost is
> the same but you're just not seeing it in "top".

Yes, using top and it is URB interrupt handler where I do conversion. So 
any idea how to measure? I think I can still switch LUT to float and see 
if it makes difference.

regards
Antti

-- 
http://palosaari.fi/
