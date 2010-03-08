Return-path: <linux-media-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44323 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0CHPcG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Mar 2010 10:32:06 -0500
Received: from [192.168.0.22] (unknown [72.92.88.10])
	by smtprelay2.cesmail.net (Postfix) with ESMTPSA id E20BE34C6A
	for <linux-media@vger.kernel.org>; Mon,  8 Mar 2010 10:32:11 -0500 (EST)
Subject: Re: [git:v4l-dvb/master] ath9k: fix eeprom INI values override for
 2GHz-only cards
From: Pavel Roskin <proski@gnu.org>
To: linux-media@vger.kernel.org
In-Reply-To: <E1NnuzG-0001mT-Pv@www.linuxtv.org>
References: <E1NnuzG-0001mT-Pv@www.linuxtv.org>
Content-Type: text/plain
Date: Mon, 08 Mar 2010 10:31:55 -0500
Message-Id: <1268062315.19400.4.camel@mj>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-03-06 at 15:28 +0100, Patch from Felix Fietkau wrote:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> Among other changes, this commit:
> 
>    commit 06d0f0663e11cab4ec5f2c143a118d71a12fbbe9
>    Author: Sujith <Sujith.Manoharan@atheros.com>
>    Date:   Thu Feb 12 10:06:45 2009 +0530
> 
>    ath9k: Enable Fractional N mode
> 
> changed the hw attach code to fix up initialization values only for
> dual band devices, however the commit message did not give a reason as
> to why this would be useful or necessary.
> 
> According to tests by Jorge Boncompte, this breaks at least some
> 2GHz-only cards, so the code should be changed back to the
> unconditional INI fixup.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Jorge Boncompte <jorge@dti2.net>
> Cc: stable@kernel.org
> Tested-by: Pavel Roskin <proski@gnu.org>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Why am I getting this message?  Is there any problem with the patch?  If
not, why should I care?

-- 
Regards,
Pavel Roskin
