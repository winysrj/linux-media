Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56779 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1AGQYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 11:24:25 -0500
Received: by qwa26 with SMTP id 26so17955503qwa.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 08:24:24 -0800 (PST)
References: <AANLkTinZPP337u7nBLDdv1+rTQ1g4z0hMDjJA8Bq0WdY@mail.gmail.com>
In-Reply-To: <AANLkTinZPP337u7nBLDdv1+rTQ1g4z0hMDjJA8Bq0WdY@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <F4B17C23-061A-4D42-BD3E-04C4E3D29C8D@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [patch] new_build.git - drop videodev.h
Date: Fri, 7 Jan 2011 11:24:35 -0500
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 7, 2011, at 7:04 AM, Vincent McIntyre wrote:

> 'make tar' fails for me (building against ubuntu 2.6.32) unless I
> remove videodev.h from TARFILES.
> 
> Is this the correct thing to do here?

Yep, videodev.h goes away in 2.6.38. Will apply and push this too.

-- 
Jarod Wilson
jarod@wilsonet.com



