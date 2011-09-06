Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60967 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1IFQXQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 12:23:16 -0400
Message-ID: <4E6648EF.3070802@iki.fi>
Date: Tue, 06 Sep 2011 19:23:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
	linux-media@vger.kernel.org
Subject: Re: checkpatch.pl WARNING: Do not use whitespace before Signed-off-by:
References: <4E654F93.9060506@iki.fi> <87r53uf6tg.fsf@nemi.mork.no>	 <4E66312F.5070102@iki.fi> <1315322125.30316.1.camel@Joe-Laptop>	 <4E663C95.4080503@iki.fi> <1315325439.30316.8.camel@Joe-Laptop>
In-Reply-To: <1315325439.30316.8.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2011 07:10 PM, Joe Perches wrote:
> On Tue, 2011-09-06 at 18:30 +0300, Antti Palosaari wrote:
>> On 09/06/2011 06:15 PM, Joe Perches wrote:
>>> On Tue, 2011-09-06 at 17:41 +0300, Antti Palosaari wrote:
>>>> So what is recommended way to ensure patch is correct currently?
>>>> a) before commit
>>> Use checkpatch.
>>>> b) after commit
>>> Make the output of the commit log look like a patch.
>> --format=email
>> But still that sounds annoying, GIT is our default tool for handling
>> patches and all the other tools like checkpatch.pl should honour that
>> without any tricks. Why you don't add some detection logic to
>> checkpatch.pl or even some new switch like --git.
>
> checkpatch is, as the name shows, for patches.
>
> I think using checkpatch on commit logs is not
> really useful.

But that's what I have done every time I have added patches coming 
community. And also for my own patches. And when problem is found it is 
easy to git commit --amend and fix it. I think I am not the only 
maintainer who checks incoming patches like this way - you will got 
surely more feedback when that version of checkpatch will get more usage.

> If you're using checkpatch on commit logs, format
> the commit log output appropriately or use
> --ignore=BAD_SIGN_OFF or add that --ignore=
> to a .checkpatch.conf if you really must.

hmm, lets see. Maybe I will add --format=email as keyboard shortcut button.


Antti


-- 
http://palosaari.fi/
