Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-006.synserver.de ([212.40.185.6]:1044 "EHLO
	smtp-out-006.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbbAPLa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 06:30:26 -0500
Message-ID: <54B8F650.1090308@metafoo.de>
Date: Fri, 16 Jan 2015 12:30:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Fabio Estevam <fabio.estevam@freescale.com>,
	mchehab@osg.samsung.com
CC: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] adv7180: Remove the unneeded 'err' label
References: <1418748547-12308-1-git-send-email-fabio.estevam@freescale.com> <1418748547-12308-2-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1418748547-12308-2-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2014 05:49 PM, Fabio Estevam wrote:
> There is no need to jump to the 'err' label as we can simply return the error
> code directly and make the code shorter.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

