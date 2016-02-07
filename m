Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:43720 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbcBGV5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2016 16:57:02 -0500
Received: from [192.168.1.138] (c-ce09e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.9.206])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id A4B91F1468
	for <linux-media@vger.kernel.org>; Sun,  7 Feb 2016 22:47:20 +0100 (CET)
Subject: Re: [PATCH 2/4] mn88473: finalize driver
To: linux-media@vger.kernel.org
References: <1454874890-10724-1-git-send-email-crope@iki.fi>
 <1454874890-10724-3-git-send-email-crope@iki.fi>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <56B7BB68.4090509@southpole.se>
Date: Sun, 7 Feb 2016 22:47:20 +0100
MIME-Version: 1.0
In-Reply-To: <1454874890-10724-3-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2016 08:54 PM, Antti Palosaari wrote:
> Finalize the driver.
> It still lacks a lot of features, like all statistics and PLP
> filtering, but basic functionality and sensitivity is pretty good
> shape.
>
> Signed-off-by: Antti Palosaari<crope@iki.fi>
Reviewed-by: Benjamin Larsson <benjamin@southpole.se>
