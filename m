Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47857 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab2DCKLR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 06:11:17 -0400
Message-ID: <4F7ACCC1.20503@iki.fi>
Date: Tue, 03 Apr 2012 13:11:13 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH 4/5 v2] af9035: fix warning
References: <GmailId1367538da899604d> <1333413178-20737-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333413178-20737-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.04.2012 03:32, Gianluca Gennari wrote:
> On a 32 bit system:
>
> af9035.c: In function 'af9035_download_firmware':
> af9035.c:446:3: warning: format '%lu' expects argument of type 'long unsigned
> int', but argument 3 has type 'unsigned int' [-Wformat]
>
> %zu avoids any warning on both 32 and 64 bit systems.
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>

Applied thanks!
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

regards
Antti
-- 
http://palosaari.fi/
