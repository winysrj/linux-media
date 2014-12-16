Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-196.synserver.de ([212.40.185.196]:1059 "EHLO
	smtp-out-179.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983AbaLPVUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 16:20:54 -0500
Message-ID: <5490A226.1000204@metafoo.de>
Date: Tue, 16 Dec 2014 22:20:38 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Fabio Estevam <fabio.estevam@freescale.com>,
	mchehab@osg.samsung.com
CC: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] adv7180: Simplify PM hooks
References: <1418748547-12308-1-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1418748547-12308-1-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2014 05:49 PM, Fabio Estevam wrote:
> The macro SIMPLE_DEV_PM_OPS already takes care of the CONFIG_PM_SLEEP=n case.

I guess that's kind of debatable. The purpose of ifdef-ing stuff out is to 
decrease the driver size if PM support is disabled. With this change you are 
adding a rather large struct which is all NULL to the driver even if PM is 
disabled. Previously this was not the case.
