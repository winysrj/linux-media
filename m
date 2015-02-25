Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33682 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbbBYSNz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 13:13:55 -0500
Message-ID: <54EE10DD.9020205@iki.fi>
Date: Wed, 25 Feb 2015 20:13:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
CC: "mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] xc5000: fix memory corruption when unplugging device
References: <1424798958-2819-1-git-send-email-dheitmueller@kernellabs.com>	<54EDD761.6060900@osg.samsung.com> <CAGoCfiyN_iQ6vGn0YGUD_OxngwKEMs056Gzp4yW9wWjSa8Lisw@mail.gmail.com>
In-Reply-To: <CAGoCfiyN_iQ6vGn0YGUD_OxngwKEMs056Gzp4yW9wWjSa8Lisw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/25/2015 07:56 PM, Devin Heitmueller wrote:
>> I would request you to add a comment here indicating the
>> hybrid case scenario to avoid any future cleanup type work
>> deciding there is no need to set priv->firmware to null
>> since priv gets released in hybrid_tuner_release_state(priv);
>
> No, I'm not going to rebase my tree and regenerate the patch just to
> add a comment explaining how hybrid_tuner_[request/release]_state()
> works (which, btw, is how it works in all hybrid tuner drivers).  I
> already wasted enough of my time tracking down the source of the
> memory corruption and providing a fix for this regression.  If you
> want to submit a subsequent patch with a comment, be my guest.

These are just the issues I would like to implement drivers as standard 
I2C driver model =) Attaching driver for one chip twice is ugly hack!

regards
Antti

-- 
http://palosaari.fi/
