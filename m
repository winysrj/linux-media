Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585Ab0CKXAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 18:00:42 -0500
Date: Thu, 11 Mar 2010 14:59:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"julia@diku.dk" <julia@diku.dk>
Subject: Re: [patch 2/5] drivers/media/video: move dereference after NULL
 test
Message-Id: <20100311145959.287e504e.akpm@linux-foundation.org>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016A5A3F25@dlee06.ent.ti.com>
References: <201003112202.o2BM2HpB013125@imap1.linux-foundation.org>
	<A69FA2915331DC488A831521EAE36FE4016A5A3F25@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Mar 2010 16:38:21 -0600
"Karicheri, Muralidharan" <m-karicheri2@ti.com> wrote:

> >diff -puN drivers/media/video/davinci/vpif_display.c~drivers-media-video-
> >move-dereference-after-null-test drivers/media/video/davinci/vpif_display.c
> >--- a/drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-
> >dereference-after-null-test
> >+++ a/drivers/media/video/davinci/vpif_display.c
> >@@ -383,8 +383,6 @@ static int vpif_get_std_info(struct chan
> > 	int index;
> >
> > 	std_info->stdid = vid_ch->stdid;
> >-	if (!std_info)
> >-		return -1;
> 
> Please change it as 
> 
> if (!std_info->stdid)
> 	return -1;

Could you please do this, and send the patch?  It's better that way as
you're more familar with the code and maybe can even test it.

