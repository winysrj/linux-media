Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48709 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2BGSKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 13:10:22 -0500
Received: by eaah12 with SMTP id h12so2914895eaa.19
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2012 10:10:21 -0800 (PST)
Message-ID: <4F31690A.1050509@gmail.com>
Date: Tue, 07 Feb 2012 19:10:18 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andy Furniss <andyqos@ukfsn.org>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org> <4F313BDC.1000100@ukfsn.org>
In-Reply-To: <4F313BDC.1000100@ukfsn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 07/02/2012 15:57, Andy Furniss ha scritto:

> It will still fail if it has already failed and not been replugged.
> 
> It's not failing to allocate - it's just not trying to allocate AFAICT ,
> which I guess counts as a bug?

For what is worth, on the MIPS STB I can't even rmmod the em28xx module
and reload it, as rmmod gets stuck.
The only solution to get the PCTV working again is a reboot.

Regards,
Gianluca
