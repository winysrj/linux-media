Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:34823 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760996Ab2CPKQS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 06:16:18 -0400
Message-ID: <4F6312F0.1010305@ukfsn.org>
Date: Fri, 16 Mar 2012 10:16:16 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: pre-allocate DVB isoc transfer buffers
References: <1329155962-22896-1-git-send-email-gennarone@gmail.com> <4F628886.3050009@ukfsn.org> <4F6299A4.1060309@gmail.com>
In-Reply-To: <4F6299A4.1060309@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gianluca Gennari wrote:
> Il 16/03/2012 01:25, Andy Furniss ha scritto:
>>
>> Does this patch have a chance of getting in?
>>
>> I am still having to flush caches before use. If you want more testing I
>> can give it a go. I didn't earlier as I didn't have a git to apply it to
>> and thought it was going to get in anyway.
>>
>
> Hi Andy,
> the patch is already in the current media_build tree and is queued for
> kernel 3.4.

Ahh, I'll give that a try, thanks.
