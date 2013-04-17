Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:58354 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966919Ab3DQWaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 18:30:08 -0400
Received: by mail-la0-f42.google.com with SMTP id fn20so1990487lab.1
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 15:30:05 -0700 (PDT)
Message-ID: <516F223C.2010704@cogentembedded.com>
Date: Thu, 18 Apr 2013 02:29:16 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: linux-media@vger.kernel.org, matsu@igel.co.jp
Subject: Re: [PATCH 3/4] ARM: shmobile: Marzen: add VIN and ADV7180 support
References: <201304180206.39465.sergei.shtylyov@cogentembedded.com> <201304180215.01218.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304180215.01218.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04/18/2013 02:15 AM, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> Add ADV7180 platform devices on the Marzen board, configure VIN1/3 pins, and
> register VIN1/3 devices with the ADV7180 specific platform data.
>
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>
> ---
>   arch/arm/mach-shmobile/board-marzen.c |   55 ++++++++++++++++++++++++++++++++++
>   1 file changed, 55 insertions(+)

    Oops, should have updated copyrights on this file. :-/
    Well, this is probably not the last version of the patchset 
anyway... :-)

WBR, Sergei

