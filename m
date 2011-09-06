Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:52797 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab1IFHuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 03:50:24 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: checkpatch.pl WARNING: Do not use whitespace before Signed-off-by:
References: <4E654F93.9060506@iki.fi>
Date: Tue, 06 Sep 2011 09:50:19 +0200
In-Reply-To: <4E654F93.9060506@iki.fi> (Antti Palosaari's message of "Tue, 06
	Sep 2011 01:39:15 +0300")
Message-ID: <87r53uf6tg.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari <crope@iki.fi> writes:

> I am almost sure this have been working earlier, but now it seems like
> nothing is acceptable for checkpatch.pl! I did surely about 20 --amend
> and tried to remove everything, without luck. Could someone point out
> whats new acceptable logging format for checkpatch.pl ?
>
> [crope@localhost linux]$ git show
> 1b19e42952963ae2a09a655f487de15b7c81c5b7 |./scripts/checkpatch.pl -
> WARNING: Do not use whitespace before Signed-off-by:

Don't know if checkpatch used to accept that, but you can use
"--format=email" to make it work with git show:

 bjorn@canardo:/usr/local/src/git/linux$ git show --format=email 1b19e42952963ae2a09a655f487de15b7c81c5b7|./scripts/checkpatch.pl -
 total: 0 errors, 0 warnings, 48 lines checked

 Your patch has no obvious style problems and is ready for submission.



Bjørn
