Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52705 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564Ab2CPBiO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 21:38:14 -0400
Received: by wibhq7 with SMTP id hq7so118181wib.1
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 18:38:13 -0700 (PDT)
Message-ID: <4F629982.2070206@gmail.com>
Date: Fri, 16 Mar 2012 02:38:10 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andy Furniss <andyqos@ukfsn.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: pre-allocate DVB isoc transfer buffers
References: <1329155962-22896-1-git-send-email-gennarone@gmail.com> <4F628886.3050009@ukfsn.org>
In-Reply-To: <4F628886.3050009@ukfsn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 16/03/2012 01:25, Andy Furniss ha scritto:

> Does this patch have a chance of getting in?
> 
> I am still having to flush caches before use. If you want more testing I
> can give it a go. I didn't earlier as I didn't have a git to apply it to
> and thought it was going to get in anyway.

Hi Andy,
the patch is already in the current media_build tree and is queued for
kernel 3.4.

Regards,
Gianluca


