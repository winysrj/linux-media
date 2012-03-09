Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46429 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2CIM0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 07:26:09 -0500
Received: by eaaq12 with SMTP id q12so430072eaa.19
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2012 04:26:08 -0800 (PST)
Message-ID: <4F59F6DE.4060704@gmail.com>
Date: Fri, 09 Mar 2012 13:26:06 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH] disable IR_GPIO_CIR module for kernels older than 2.6.35
References: <1331295569-25158-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331295569-25158-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, I forgot the [media_build] tag.
This patch is required to fix compilation of the media_buid tree on my
Ubuntu 10.04 system with kernel 2.6.32.

Regards,
Gianluca
