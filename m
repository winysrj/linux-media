Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:53712 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbaLUUHL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Dec 2014 15:07:11 -0500
Message-ID: <54972866.3030101@gentoo.org>
Date: Sun, 21 Dec 2014 21:07:02 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Should the commit message directly point to the breaking commit
36efec48e2e6016e05364906720a0ec350a5d768?

This commit hopefully reverts the problematic attach for the Starburst
card. I kept the GPIO-part in common, but I can split this also if
necessary.

Regards
Matthias

