Return-path: <linux-media-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:59980 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754766Ab1IFPPZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:15:25 -0400
Subject: Re: checkpatch.pl WARNING: Do not use whitespace before
 Signed-off-by:
From: Joe Perches <joe@perches.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-media@vger.kernel.org
Date: Tue, 06 Sep 2011 08:15:24 -0700
In-Reply-To: <4E66312F.5070102@iki.fi>
References: <4E654F93.9060506@iki.fi> <87r53uf6tg.fsf@nemi.mork.no>
	 <4E66312F.5070102@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315322125.30316.1.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-09-06 at 17:41 +0300, Antti Palosaari wrote:
> So what is recommended way to ensure patch is correct currently?
> a) before commit

Use checkpatch.

> b) after commit

Make the output of the commit log look like a patch.


