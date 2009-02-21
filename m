Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59266 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754752AbZBULsB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 06:48:01 -0500
Message-ID: <499FE9ED.7050405@gmx.de>
Date: Sat, 21 Feb 2009 12:47:57 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
References: <200902211200.45373.hverkuil@xs4all.nl>
In-Reply-To: <200902211200.45373.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Comments?
>
> 	Hans
>   

As only beeing reader of this list.., why not simply reduce the work load by

- reducing the number of supported kernel versions to five major 
versions? Currently 2.6.28 would mean down to 2.6.23,
this would be enough cover all nearly up-to-date distributions. Users 
from embedded devices are anyway mostly not able to compile or use newer 
drivers.

- not changing to git, already since this generates a lot of work
Not too far away dev was changed from cvs to hg, and already there some 
pieces are left over (for example that api stuff).

- force users to upgrade their kernel if (breaking these backward 
compat, and only if) *major* upgrades inside standard kernel would 
require a very huge amount of backporting, for example that i2c stuff.

I guess such solution would help immediately.

--Winfried





