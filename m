Return-path: <mchehab@pedra>
Received: from smtp-out.google.com ([216.239.44.51]:5567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1CIUHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 15:07:00 -0500
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p29K6xjh010821
	for <linux-media@vger.kernel.org>; Wed, 9 Mar 2011 12:06:59 -0800
Received: from vxb39 (vxb39.prod.google.com [10.241.33.103])
	by wpaz21.hot.corp.google.com with ESMTP id p29K6vwj006838
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-media@vger.kernel.org>; Wed, 9 Mar 2011 12:06:58 -0800
Received: by vxb39 with SMTP id 39so1076266vxb.15
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2011 12:06:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110308110412.73ea8be9@bike.lwn.net>
References: <201103080913.59231.hverkuil@xs4all.nl>
	<20110308110412.73ea8be9@bike.lwn.net>
Date: Wed, 9 Mar 2011 12:06:56 -0800
Message-ID: <AANLkTi=bL5b-UCreSgG85geo+5qNMFZTgO4CKHbUfFZW@mail.gmail.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Hugh Dickins <hughd@google.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org, Jonghun Han <jonghun.han@samsung.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 10:04 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 8 Mar 2011 09:13:59 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> All these memory-related modules have the same purpose: make it possible to
>> allocate/reserve large amounts of memory and share it between different
>> subsystems (primarily framebuffer, GPU and V4L).
>>
>> It really shouldn't be that hard to get everyone involved together and settle
>> on a single solution (either based on an existing proposal or create a 'the
>> best of' vendor-neutral solution).
>
> There is a memory management summit at the LF Collaboration Summit next
> month.  Perhaps this would be a good topic to raise there?  I've added
> Hugh to the Cc list in case he has any thoughts on the matter - and
> besides, he doesn't have enough to do...:)

It's a good suggestion, Jon, thank you.  But I don't see that any of
the prime movers in this area have applied to come to LSF/MM this
year: except for Kamezawa-san, who is coming (but I expect will be
focussing on other issues).  And now we're full up.

Let me keep it in mind when drawing up the agenda; but I doubt this
will be the forum to get such a ball rolling this year.

Hugh
