Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174Ab0BHCz7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 21:55:59 -0500
Message-ID: <4B6F7D37.50404@redhat.com>
Date: Mon, 08 Feb 2010 00:55:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 8/12] tm6000: add tuner parameter
References: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-2-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-3-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-4-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-5-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-6-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-7-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410631-11955-7-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stefan.ringel@arcor.de wrote:

> +		ctl.vhfbw7 = 1;
> +		ctl.uhfbw8 = 1;

I don't think you need to set this, as the driver will automatically do the firmware
tricks for the firmwares. This will probably just change the default to start
wit firmware 7/8.

-- 

Cheers,
Mauro
