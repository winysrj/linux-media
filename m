Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39600 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1JKWZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 18:25:40 -0400
Received: by ggnv2 with SMTP id v2so66674ggn.19
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 15:25:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E94BD75.5040403@mlbassoc.com>
References: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
	<4E94BD75.5040403@mlbassoc.com>
Date: Wed, 12 Oct 2011 00:25:39 +0200
Message-ID: <CA+2YH7vx27qNeOO33NmR4SaqrSrhdu=17p468cSbLxDKfDAQqQ@mail.gmail.com>
Subject: Re: [RFC 0/3] omap3isp: add BT656 support
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 12, 2011 at 12:04 AM, Gary Thomas <gary@mlbassoc.com> wrote:
> Sorry, this just locks up on boot for me, immediately after finding the
> TVP5150.
> I applied your changes to the above tree
>  commit 658d5e03dc1a7283e5119cd0e9504759dbd3d912
>  Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  Date:   Wed Aug 31 16:03:53 2011 +0200

Did you add Javier patches for the tvp5150?


> However, it does not build for my OMAP3530 without the attached patches.

I can't remember now if i had omap vout enabled in my kernel config
but that one in ispccdc.c is strange, tomorrow i will do again a clean
rebuild.

Enrico
