Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45329 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbcF1NkF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 09:40:05 -0400
Subject: Re: [PATCH] media: s5p-mfc fix memory leak in s5p_mfc_remove()
To: Kamil Debski <k.debski@samsung.com>, kyungmin.park@samsung.com,
	jtp.park@samsung.com, mchehab@osg.samsung.com
References: <1465847114-7427-1-git-send-email-shuahkh@osg.samsung.com>
 <025e01d1d123$7c14e620$743eb260$@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <57727E2C.9040102@osg.samsung.com>
Date: Tue, 28 Jun 2016 07:39:56 -0600
MIME-Version: 1.0
In-Reply-To: <025e01d1d123$7c14e620$743eb260$@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2016 03:57 AM, Kamil Debski wrote:
> HI Shuah,
> 
> Which branch do you base your patches on?
> 
> I have trouble applying this path
> (https://patchwork.linuxtv.org/patch/34577/) and 
> "s5p-mfc fix null pointer deference in clk_core_enable()"
> (https://patchwork.linuxtv.org/patch/34751/) 
> onto current linuxtv/master.
> 
> The top commit of linuxtv/master is :
> "commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05
> Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Date:   Thu Jun 16 08:04:40 2016 -0300
> 
>     [media] media-devnode.h: Fix documentation"
> 
> Could you please rebase the two patches mentioned above to the
> linuxtv/master?
> 
> Best wishes,
> 

I based them on linux_next. I will rebase both patches on linuxtv/master
and resend.

thanks,
-- Shuah
