Return-path: <linux-media-owner@vger.kernel.org>
Received: from infra.metatux.net ([78.46.58.246]:41112 "EHLO infra.metatux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3D1Rmb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 13:42:31 -0400
Message-ID: <517D5F74.2050106@metatux.net>
Date: Sun, 28 Apr 2013 19:42:12 +0200
From: Lars Buerding <lindvb@metatux.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 00/31] Add r820t support at rtl28xxu
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.04.2013 02:42, Mauro Carvalho Chehab wrote:
> Add a tuner driver for Rafael Micro R820T silicon tuner.
>
> This tuner seems to be popular those days. Add support for it
> at rtl28xxu.
>
> This tuner was written from scratch, based on rtl-sdr driver.

Thanks Mauro, applied your patches to a vanilla v3.8.10 kernel yesterday, and a Nooelec r820t stick is working fine with it receiving DVB-T for a VDR. 
Not any issues so far.


Best regards,
Lars

