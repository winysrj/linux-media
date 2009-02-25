Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49646 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750999AbZBYR6m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 12:58:42 -0500
Message-ID: <49A586CE.7030600@gmx.de>
Date: Wed, 25 Feb 2009 18:58:38 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <200902221115.01464.hverkuil@xs4all.nl>
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>
> _: Yes
> _: No
>
>   
YES.

> Optional question:
>
> Why:
>   
I assume that the main goal should be development of linux v4l/dvb 
drivers to be included in *new* kernel versions. These dont need compat 
code.
But beside of the main goal there are requirements and other goals

- simplify development and save time (skip)
- keep code as easy as possible (skip)
- having as many testers as needed (don't skip or choose kernel version 
suitable)
- support of linux users who aren't able to update (either dont skip or 
provide backports in regular intervals. still easier to implement)


looking at this it will hurt only users from embedded hardwrae, but at 
least a bunch of them cannot compile modules anyway.
Might be solved by (i.e. yearly) backports.

Would be also interesting which kernel versions are used by list members.
