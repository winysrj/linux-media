Return-path: <linux-media-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:49030 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751804Ab1IFQbw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 12:31:52 -0400
Subject: Re: checkpatch.pl WARNING: Do not use whitespace before
 Signed-off-by:
From: Joe Perches <joe@perches.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-media@vger.kernel.org
Date: Tue, 06 Sep 2011 09:31:51 -0700
In-Reply-To: <4E6648EF.3070802@iki.fi>
References: <4E654F93.9060506@iki.fi> <87r53uf6tg.fsf@nemi.mork.no>
	 <4E66312F.5070102@iki.fi> <1315322125.30316.1.camel@Joe-Laptop>
	 <4E663C95.4080503@iki.fi> <1315325439.30316.8.camel@Joe-Laptop>
	 <4E6648EF.3070802@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315326711.30316.12.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-09-06 at 19:23 +0300, Antti Palosaari wrote:
> hmm, lets see. Maybe I will add --format=email as keyboard shortcut button.

or add 

[format]
	pretty = email

to your .gitconfig or create and use a
check_commitlog shell script or...

