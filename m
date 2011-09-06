Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49191 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab1IFOl7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 10:41:59 -0400
Message-ID: <4E66312F.5070102@iki.fi>
Date: Tue, 06 Sep 2011 17:41:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
	Joe Perches <joe@perches.com>
CC: linux-media@vger.kernel.org
Subject: Re: checkpatch.pl WARNING: Do not use whitespace before Signed-off-by:
References: <4E654F93.9060506@iki.fi> <87r53uf6tg.fsf@nemi.mork.no>
In-Reply-To: <87r53uf6tg.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2011 10:50 AM, Bjørn Mork wrote:
> Antti Palosaari<crope@iki.fi>  writes:
>
>> I am almost sure this have been working earlier, but now it seems like
>> nothing is acceptable for checkpatch.pl! I did surely about 20 --amend
>> and tried to remove everything, without luck. Could someone point out
>> whats new acceptable logging format for checkpatch.pl ?
>>
>> [crope@localhost linux]$ git show
>> 1b19e42952963ae2a09a655f487de15b7c81c5b7 |./scripts/checkpatch.pl -
>> WARNING: Do not use whitespace before Signed-off-by:
>
> Don't know if checkpatch used to accept that, but you can use
> "--format=email" to make it work with git show:
>
>   bjorn@canardo:/usr/local/src/git/linux$ git show --format=email 1b19e42952963ae2a09a655f487de15b7c81c5b7|./scripts/checkpatch.pl -
>   total: 0 errors, 0 warnings, 48 lines checked
>
>   Your patch has no obvious style problems and is ready for submission.

Yes, I found it. It was rather new patch adding more checks.
As a you pointed that can be workaround giving --format=email as a param 
for git show. But it is yet another "useless" param to remember...

So what is recommended way to ensure patch is correct currently?
a) before commit
b) after commit


commit 2011247550c1b903a9ecd68f6eb3e9e7b7b07f52
Author: Joe Perches <joe@perches.com>
Date:   Mon Jul 25 17:13:23 2011 -0700

     checkpatch: validate signature styles and To: and Cc: lines

     Signatures have many forms and can sometimes cause problems if not 
in the
     correct format when using git send-email or quilt.

     Try to verify the signature tags and email addresses to use the 
generally
     accepted "Signed-off-by: Full Name <email@domain.tld>" form.

     Original idea by Anish Kumar <anish198519851985@gmail.com>


regards
Antti


-- 
http://palosaari.fi/
