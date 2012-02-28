Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:42734 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965099Ab2B1LEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 06:04:23 -0500
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:9ce4])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 859ED940114
	for <linux-media@vger.kernel.org>; Tue, 28 Feb 2012 12:04:16 +0100 (CET)
Date: Tue, 28 Feb 2012 12:05:48 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 3.4] gspca for_v3.4
Message-ID: <20120228120548.186ee4bc@tele>
In-Reply-To: <4F4BE111.6090805@gmail.com>
References: <20120227130606.1f432e7b@tele>
 <4F4BE111.6090805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Feb 2012 21:01:21 +0100
Sylwester Nawrocki <snjw23@gmail.com> wrote:

> This patch will conflict with patch:
> 
>  gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
> 
> from my recent pull request http://patchwork.linuxtv.org/patch/10022/
> 
> How should we proceed with that ? Do you want me to remove the above patch 
> from my pull request, or would you rebase your change set on top of mine ?

Hi Sylwester,

Sorry for the problem, I thought your patch was already in the media
tree.

I checked the changes in zc3xx.c, and I have made many commits. So, it
would be simpler if you would remove your patch. I could give you a
merged one once the media tree would be updated.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
