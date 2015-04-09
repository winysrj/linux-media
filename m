Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36250 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbbDIP1K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 11:27:10 -0400
Received: by qku63 with SMTP id 63so127912444qku.3
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2015 08:27:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <trinity-697dde81-bae2-4f42-b8af-ea4e14573136-1428592989284@3capp-gmx-bs54>
References: <trinity-697dde81-bae2-4f42-b8af-ea4e14573136-1428592989284@3capp-gmx-bs54>
Date: Thu, 9 Apr 2015 11:27:09 -0400
Message-ID: <CAGoCfizGF+8SHMT34_c5eoJ7z9Tmm_c_=Gfp1dPxNH-=L8PaxA@mail.gmail.com>
Subject: Re: kconf syntax error when doing make menuconfig
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Amex@gmx.de
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> i also get this with make xconfig. just running ./build, however, works

Yeah, I've seen that before.  It's a whitespace bug in the KConfig
file.  Just open it in a text editor, go to the line in question, and
fix the leading whitespace to match all the other entries (If I
recall, you'll actually see it occur in two or three places).

It's a trivial fix - feel free to submit a patch so people don't hit
it in the future.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
