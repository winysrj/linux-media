Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:35272 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1G0S5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 14:57:34 -0400
Received: from [192.168.1.12] (c-83-233-52-54.cust.bredband2.com [83.233.52.54])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPSA id 8FBAC2525C
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 20:50:57 +0200 (CEST)
Message-ID: <4E305E00.5080604@southpole.se>
Date: Wed, 27 Jul 2011 20:50:40 +0200
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] IT9137 driver for Kworld UB499-2T T09 (id 1b80:e409)
 - firmware details
References: <1311618885.7655.3.camel@localhost> <4E305962.4090208@redhat.com>
In-Reply-To: <4E305962.4090208@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Malcolm,
>
> You should add a rule like the above at:
> 	Documentation/dvb/get_dvb_firmware

My patch does exactly that.

[PATCH] Firmware extraction for IT9135 based devices


> if you cannot get the distribution rights for such firmware.
>
> Thanks,
> Mauro

MvH
Benjamin Larsson
