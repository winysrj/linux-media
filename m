Return-path: <linux-media-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42707 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755191Ab1IFQKj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 12:10:39 -0400
Subject: Re: checkpatch.pl WARNING: Do not use whitespace before
 Signed-off-by:
From: Joe Perches <joe@perches.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-media@vger.kernel.org
Date: Tue, 06 Sep 2011 09:10:38 -0700
In-Reply-To: <4E663C95.4080503@iki.fi>
References: <4E654F93.9060506@iki.fi> <87r53uf6tg.fsf@nemi.mork.no>
	 <4E66312F.5070102@iki.fi> <1315322125.30316.1.camel@Joe-Laptop>
	 <4E663C95.4080503@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315325439.30316.8.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-09-06 at 18:30 +0300, Antti Palosaari wrote:
> On 09/06/2011 06:15 PM, Joe Perches wrote:
> > On Tue, 2011-09-06 at 17:41 +0300, Antti Palosaari wrote:
> >> So what is recommended way to ensure patch is correct currently?
> >> a) before commit
> > Use checkpatch.
> >> b) after commit
> > Make the output of the commit log look like a patch.
> --format=email
> But still that sounds annoying, GIT is our default tool for handling 
> patches and all the other tools like checkpatch.pl should honour that 
> without any tricks. Why you don't add some detection logic to 
> checkpatch.pl or even some new switch like --git.

checkpatch is, as the name shows, for patches.

I think using checkpatch on commit logs is not
really useful.

If you're using checkpatch on commit logs, format
the commit log output appropriately or use
--ignore=BAD_SIGN_OFF or add that --ignore=
to a .checkpatch.conf if you really must.


