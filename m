Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40019 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966149Ab3DRO0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 10:26:21 -0400
Received: by mail-lb0-f178.google.com with SMTP id q13so2772066lbi.9
        for <linux-media@vger.kernel.org>; Thu, 18 Apr 2013 07:26:19 -0700 (PDT)
Message-ID: <51700247.2000905@cogentembedded.com>
Date: Thu, 18 Apr 2013 18:25:11 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: linux-media@vger.kernel.org, matsu@igel.co.jp,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH 3/4] ARM: shmobile: Marzen: add VIN and ADV7180 support
References: <201304180206.39465.sergei.shtylyov@cogentembedded.com> <201304180215.01218.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304180215.01218.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18-04-2013 2:15, I wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

> Add ADV7180 platform devices on the Marzen board, configure VIN1/3 pins, and
> register VIN1/3 devices with the ADV7180 specific platform data.

> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

    I'm going to repost this patch recasted using a macro for camera sensor data.

WBR, Sergei

