Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:63833 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbDPUJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 16:09:32 -0400
Date: Thu, 16 Apr 2015 22:03:26 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] rc-core: use an IDA rather than a bitmap
Message-ID: <20150416220326.30aa6801@mir>
In-Reply-To: <20150402101855.5223.5158.stgit@zeus.muc.hardeman.nu>
References: <20150402101855.5223.5158.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 2015-04-02, David Härdeman wrote:
> This patch changes rc-core to use the kernel facilities that are already
> available for handling unique numbers instead of rolling its own bitmap
> stuff.
> 
> Stefan, this should apply cleanly to the media git tree...could you test it?
> ---
>  drivers/media/rc/rc-ir-raw.c |    2 +-
>  drivers/media/rc/rc-main.c   |   40 ++++++++++++++++++++--------------------
>  include/media/rc-core.h      |    4 ++--
>  3 files changed, 23 insertions(+), 23 deletions(-)

Just some preliminary feedback after two weeks of testing. 

So far the problem with multiple rc_core devices fighting over the same 
sysfs file hasn't occured again, but it's a bit too early to be 
completely sure about it (probably 4-5 more weeks before I can be 
(relatively) confident that the problem is really gone). 

With this patch applied, everything continues to work fine for me; I 
haven't noticed any problems.

Thanks a lot
	Stefan Lippers-Hollmann
