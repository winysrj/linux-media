Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:58744 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbbCPUof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 16:44:35 -0400
Message-ID: <550740A7.2080809@southpole.se>
Date: Mon, 16 Mar 2015 21:44:23 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: crope@iki.fi, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/10] rtl28xxu: swap frontend order for slave demods
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-4-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-4-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2015 11:57 PM, Benjamin Larsson wrote:
> Some devices have 2 demodulators, when this is the case
> make the slave demod be listed first. Enumerating the slave
> first will help legacy applications to use the hardware.
>

Ignore this patch for now. Stuff gets broken if applied.

/Benjamin

