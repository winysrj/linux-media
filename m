Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53656 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab1AZPO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 10:14:56 -0500
Received: by eye27 with SMTP id 27so492329eye.19
        for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 07:14:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8C123C68-4541-4DC8-9F3C-B887AC247DA7@wilsonet.com>
References: <AANLkTiktFYcJwJePy=jjeo2qGHWip52cZyCkCDTgdFmc@mail.gmail.com>
	<AANLkTimn5nPjsZnJ2NVrpXkBZamhiPSf-R6jSpZixCwS@mail.gmail.com>
	<AANLkTimcM8fy9Cu8Xuk=M74WBnfoG9gyb7zLqcQV2Hoa@mail.gmail.com>
	<8C123C68-4541-4DC8-9F3C-B887AC247DA7@wilsonet.com>
Date: Wed, 26 Jan 2011 10:14:54 -0500
Message-ID: <AANLkTikt0Lua2OEDtF2WvCVB3U-kfatwNkirr5vwStoF@mail.gmail.com>
Subject: Re: Is media_build download broken?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: VDR User <user.vdr@gmail.com>,
	"mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 26, 2011 at 9:38 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
> Seems that an explicit 'pull over ssh' command was recently added
> to media_build, which only works if you've got a shell account on
> linuxtv.org. I'll ask Mauro about it and/or just fix it.

He should just have to do "git://" instead of "ssh://"

git pull git://linuxtv.org/git/media_build master

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
