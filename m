Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58854 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbaGINWp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 09:22:45 -0400
Message-ID: <53BD421F.8020904@gmail.com>
Date: Wed, 09 Jul 2014 18:52:39 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: m.chehab@samsung.com, dan.carpenter@oracle.com,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: nokia_h4p: nokia_core.c - removed IRQF_DISABLED
 macro
References: <1404885998-10981-1-git-send-email-askb23@gmail.com> <1404885998-10981-2-git-send-email-askb23@gmail.com> <20140709114605.GB22777@amd.pavel.ucw.cz>
In-Reply-To: <20140709114605.GB22777@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Wednesday 09 July 2014 05:16 PM, Pavel Machek wrote:
> I wonder if it would maek sense to do
> ./include/linux/interrupt.h:#define IRQF_DISABLED 0 to make it extra
> clear that it is nop now? Pavel 
yes - it makes sense. there are still a few references to the macro in
the code.

Cheers,
Anil
