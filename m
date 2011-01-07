Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63298 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1AGQXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 11:23:50 -0500
Received: by qwa26 with SMTP id 26so17955005qwa.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 08:23:49 -0800 (PST)
References: <AANLkTinUVpHdJRZ_EHw8B4nv=X2yNoOwdNqtH_+wiV=r@mail.gmail.com>
In-Reply-To: <AANLkTinUVpHdJRZ_EHw8B4nv=X2yNoOwdNqtH_+wiV=r@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <6B50A1B6-ED80-46CB-996F-86F4F1BF4C35@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [patch] new_build.git - avoid failing on 'rm' of nonexistent file
Date: Fri, 7 Jan 2011 11:23:59 -0500
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 7, 2011, at 6:53 AM, Vincent McIntyre wrote:

> While attempting to build recently I have found the 'make distclean'
> target fails if 'rm' tries to remove a file that is not there. The
> attached patch fixes the issue for me (by using rm -f).
> I converted all the other 'rm' calls to 'rm -f' along the way.
> 
> Please consider applying this.

Yeah, I did the same earlier for another target, I'll go ahead and get
it applied and pushed.

-- 
Jarod Wilson
jarod@wilsonet.com



