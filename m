Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:46187 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2JBJSb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 05:18:31 -0400
Date: Tue, 2 Oct 2012 11:18:35 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC PATCH 3/3] fsl-viu: fix compiler warning.
Message-ID: <20121002111835.33370c16@wker>
In-Reply-To: <72ee06310ede2a3f842528fc1ed0025ab15ff8a3.1349168132.git.hans.verkuil@cisco.com>
References: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
	<72ee06310ede2a3f842528fc1ed0025ab15ff8a3.1349168132.git.hans.verkuil@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue,  2 Oct 2012 10:57:20 +0200
Hans Verkuil <hans.verkuil@cisco.com> wrote:

> drivers/media/platform/fsl-viu.c: In function 'vidioc_s_fbuf':
> drivers/media/platform/fsl-viu.c:867:32: warning: initialization discards 'const' qualifier from pointer target type [enabled by default]
> 
> This is fall-out from this commit:
> 
> commit e6eb28c2207b9397d0ab56e238865a4ee95b7ef9
> Author: Hans Verkuil <hans.verkuil@cisco.com>
> Date:   Tue Sep 4 10:26:45 2012 -0300
> 
>     [media] v4l2: make vidioc_s_fbuf const
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/fsl-viu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Anatolij Gustschin <agust@denx.de>

Thanks,
Anatolij
