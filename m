Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:60056 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbbEBWGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2015 18:06:32 -0400
Message-ID: <55454A65.6010307@southpole.se>
Date: Sun, 03 May 2015 00:06:29 +0200
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Christian Engelmayer <cengelma@gmx.at>, mchehab@osg.samsung.com
CC: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] mn88472: Fix possible leak in mn88472_init()
References: <1430603969-7177-1-git-send-email-cengelma@gmx.at>
In-Reply-To: <1430603969-7177-1-git-send-email-cengelma@gmx.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/02/2015 11:59 PM, Christian Engelmayer wrote:
> Commit 307e95c92257 ("[media] mn88472: implement firmware parity check")
> introduced the usage of exit paths that do not free the already allocated
> firmware data in case the parity handling fails. Go through the correct
> exit paths. Detected by Coverity CID 1295989.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

ACK

MvH
Benjamin Larsson
