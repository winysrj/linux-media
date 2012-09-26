Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34846 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2IZLEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 07:04:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media-ctl: Fix build error with newer autotools
Date: Wed, 26 Sep 2012 13:04:51 +0200
Message-ID: <10621846.5Jp7rXxUfX@avalon>
In-Reply-To: <1348497264-9667-1-git-send-email-gary@mlbassoc.com>
References: <1348497264-9667-1-git-send-email-gary@mlbassoc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Monday 24 September 2012 08:34:24 Gary Thomas wrote:
>  Rename configure.in to be configure.ac - required for newer
>  versions of autotools (older versions silently handled
>  this, now it's an error)
> 
> Signed-off-by: Gary Thomas <gary@mlbassoc.com>

Thanks for the patch. Applied and pushed.

-- 
Regards,

Laurent Pinchart

