Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3807 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaC3REL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 13:04:11 -0400
Message-ID: <53384E74.1050307@xs4all.nl>
Date: Sun, 30 Mar 2014 19:03:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christopher Li <sparse@chrisli.org>,
	Linux-Sparse <linux-sparse@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: sparse: ARRAY_SIZE and sparse array initialization
References: <532442E2.7050206@xs4all.nl>	<532443AB.9080105@xs4all.nl>	<533553E6.3060508@xs4all.nl>	<CANeU7Qksj-tq0fjsZya1otX75sV4JOsAdXHr5Kxu-WyvYrksSw@mail.gmail.com>	<533807FC.5050008@xs4all.nl> <CA+55aFy8y6ctXcc8qcqVkRDAL=ZWU0DAfuZ4zQcP6uqzPmb-AA@mail.gmail.com>
In-Reply-To: <CA+55aFy8y6ctXcc8qcqVkRDAL=ZWU0DAfuZ4zQcP6uqzPmb-AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2014 06:48 PM, Linus Torvalds wrote:
> On Sun, Mar 30, 2014 at 5:03 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> which is clearly a sparse bug somewhere.
> 
> Yes. What is going on is that we create separate symbols for each
> declaration, and we tie them all together (and warn if they have
> conflicting types).
> 
> But then when we look up a symbol, we only look at the latest one, so
> when we size the array, we look at that "extern" declaration, and
> don't see the size that was created with the initializer.
> 
> I'll think about how to fix it cleanly. Expect a patch shortly.

Great!

Tomorrow I'll try to write test cases for the two other sparse problems
I found.

Regards,

	Hans

