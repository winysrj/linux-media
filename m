Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34500 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab1IFP4J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:56:09 -0400
Message-ID: <4E663C95.4080503@iki.fi>
Date: Tue, 06 Sep 2011 18:30:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
	linux-media@vger.kernel.org
Subject: Re: checkpatch.pl WARNING: Do not use whitespace before Signed-off-by:
References: <4E654F93.9060506@iki.fi> <87r53uf6tg.fsf@nemi.mork.no>	 <4E66312F.5070102@iki.fi> <1315322125.30316.1.camel@Joe-Laptop>
In-Reply-To: <1315322125.30316.1.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2011 06:15 PM, Joe Perches wrote:
> On Tue, 2011-09-06 at 17:41 +0300, Antti Palosaari wrote:
>> So what is recommended way to ensure patch is correct currently?
>> a) before commit
>
> Use checkpatch.
>
>> b) after commit
>
> Make the output of the commit log look like a patch.

--format=email

But still that sounds annoying, GIT is our default tool for handling 
patches and all the other tools like checkpatch.pl should honour that 
without any tricks. Why you don't add some detection logic to 
checkpatch.pl or even some new switch like --git.

regards
Antti
-- 
http://palosaari.fi/
