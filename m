Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49237 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbcEQPTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 11:19:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	devel@driverdev.osuosl.org, pmchba@pmcs.com
Subject: Re: [PATCH 0/7] fix typo
References: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr>
	<874m9wpvt2.fsf@purkki.adurom.net>
	<alpine.DEB.2.10.1605171708260.3068@hadrien>
Date: Tue, 17 May 2016 18:19:06 +0300
In-Reply-To: <alpine.DEB.2.10.1605171708260.3068@hadrien> (Julia Lawall's
	message of "Tue, 17 May 2016 17:08:52 +0200 (CEST)")
Message-ID: <874m9w67bp.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Julia Lawall <julia.lawall@lip6.fr> writes:

> On Tue, 17 May 2016, Kalle Valo wrote:
>
>> Julia Lawall <Julia.Lawall@lip6.fr> writes:
>>
>> > firmare -> firmware
>> >
>> > ---
>> >
>> >  drivers/media/dvb-frontends/mn88473.c       |    2 +-
>> >  drivers/net/wireless/ath/ath6kl/core.h      |    2 +-
>> >  drivers/net/wireless/marvell/mwifiex/pcie.c |    2 +-
>>
>> It would be good to know in advance what tree you are planning to submit
>> these for. For example, should I take ath6kl and mwifiex patches or
>> someone else?
>
> I have no preference.  They are all independent in any case.

Ok, I'll then take the ath6kl and mwifiex patches.

-- 
Kalle Valo
