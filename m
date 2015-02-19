Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([37.247.8.11]:60798 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbbBSJnO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 04:43:14 -0500
Message-ID: <54E5B028.5080900@southpole.se>
Date: Thu, 19 Feb 2015 10:43:04 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
	Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] mn88472: reduce firmware download chunk size
References: <1424337200-6446-1-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1424337200-6446-1-git-send-email-a.seppala@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-02-19 10:13, Antti Seppälä wrote:
> It seems that currently the firmware download on the mn88472 is
> somehow wrong for my Astrometa HD-901T2.
>
> Reducing the download chunk size (mn88472_config.i2c_wr_max) to 2
> makes the firmware download consistently succeed.
>


Hi, try adding the workaround patch I sent for this.

[PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c transfer errors

I now see that it hasn't been merged. But I have been running with this 
patch for a few months now without any major issues.

MvH
Benjamin Larsson
