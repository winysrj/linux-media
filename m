Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39014 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2JTJ6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 05:58:39 -0400
Message-ID: <508275CB.3000603@gmail.com>
Date: Sat, 20 Oct 2012 11:58:35 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] s5p-tv: don't include linux/version.h in mixer_video.c
References: <alpine.LNX.2.00.1210182125380.17217@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1210182125380.17217@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2012 09:28 PM, Jesper Juhl wrote:
> The header is not needed, so remove it.

I have applied it to my tree, thanks!
