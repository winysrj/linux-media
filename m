Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:56762 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3JLJlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 05:41:05 -0400
Message-ID: <5259192E.9030304@gmail.com>
Date: Sat, 12 Oct 2013 11:41:02 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Seung-Woo Kim <sw0312.kim@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.chehab@samsung.com, s.nawrocki@samsung.com
Subject: Re: [PATCH] s5p-jpeg: fix encoder and decoder video dev names
References: <1381394756-17651-1-git-send-email-sw0312.kim@samsung.com>
In-Reply-To: <1381394756-17651-1-git-send-email-sw0312.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/2013 10:45 AM, Seung-Woo Kim wrote:
> It is hard to distinguish between decoder and encoder video device
> because their names are same. So this patch fixes the names.
>
> Signed-off-by: Seung-Woo Kim<sw0312.kim@samsung.com>

Patch queued for 3.13.

Thanks,
Sylwester
