Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:63967 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3DTUoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 16:44:16 -0400
Received: by mail-la0-f50.google.com with SMTP id el20so4494849lab.9
        for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 13:44:15 -0700 (PDT)
Message-ID: <5172FDEC.3070200@cogentembedded.com>
Date: Sun, 21 Apr 2013 00:43:24 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	mchehab@redhat.com, linux-media@vger.kernel.org
CC: horms@verge.net.au, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH 0/5] OKI ML86V7667 driver and R8A7778/BOCK-W VIN support
References: <201304210013.46110.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304210013.46110.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04/21/2013 12:13 AM, Sergei Shtylyov wrote:

>     Here's the set of 4 patches against the Simon Horman's 'renesas.git' repo,
> 'renesas-next-20130419' tag and my recent yet unapplied patches. Here we
> add the OKI ML86V7667 video decoder driver and the VIN platform code working on
> the R8A7778/BOCK-W with ML86V7667. The driver patch also applies (with offsets)
> to Mauro's 'media_tree.git'...
>
> [1/5] V4L2: I2C: ML86V7667 video decoder driver
> [2/5] sh-pfc: r8a7778: add VIN pin groups
> [3/5] ARM: shmobile: r8a7778: add VIN support
> [4/5] ARM: shmobile: BOCK-W: add VIN and ADV7180 support
> [5/5] ARM: shmobile: BOCK-W: enable VIN and ADV7180 in defconfig

     s/ADV7180/ML86V7667/. Sorry, used the old cover letter as a template
and forgot to fix the decoder name.

WBR, Sergei

