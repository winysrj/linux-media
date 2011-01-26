Return-path: <mchehab@pedra>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48168 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1AZT7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 14:59:11 -0500
Received: by yib18 with SMTP id 18so274718yib.19
        for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 11:59:10 -0800 (PST)
References: <AANLkTiktFYcJwJePy=jjeo2qGHWip52cZyCkCDTgdFmc@mail.gmail.com> <AANLkTimn5nPjsZnJ2NVrpXkBZamhiPSf-R6jSpZixCwS@mail.gmail.com> <AANLkTimcM8fy9Cu8Xuk=M74WBnfoG9gyb7zLqcQV2Hoa@mail.gmail.com> <8C123C68-4541-4DC8-9F3C-B887AC247DA7@wilsonet.com> <AANLkTikt0Lua2OEDtF2WvCVB3U-kfatwNkirr5vwStoF@mail.gmail.com>
In-Reply-To: <AANLkTikt0Lua2OEDtF2WvCVB3U-kfatwNkirr5vwStoF@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <96AC635D-3F2A-4178-9A37-AC92DB8DA876@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: VDR User <user.vdr@gmail.com>,
	"mailing list: linux-media" <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Is media_build download broken?
Date: Wed, 26 Jan 2011 14:59:20 -0500
To: Devin Heitmueller <dheitmueller@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 26, 2011, at 10:14 AM, Devin Heitmueller wrote:

> On Wed, Jan 26, 2011 at 9:38 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> Seems that an explicit 'pull over ssh' command was recently added
>> to media_build, which only works if you've got a shell account on
>> linuxtv.org. I'll ask Mauro about it and/or just fix it.
> 
> He should just have to do "git://" instead of "ssh://"
> 
> git pull git://linuxtv.org/git/media_build master

Looks like Mauro actually fixed it this morning.

-- 
Jarod Wilson
jarod@wilsonet.com



