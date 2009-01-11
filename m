Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZAKXUT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 18:20:19 -0500
Date: Sun, 11 Jan 2009 21:19:34 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [patch] add video_nr module param to gspca
Message-ID: <20090111211934.0317f6c5@pedra.chehab.org>
In-Reply-To: <4968EE9A.5040901@aknet.ru>
References: <4968EE9A.5040901@aknet.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stas,

Please, always copy linux-media@vger.kernel.org for patches and other subjects
related to drivers development. This will allow patchwork.kernel.org to
properly track the sent patches.

Cheers,
Mauro.

On Sat, 10 Jan 2009 21:53:14 +0300
Stas Sergeev <stsp@aknet.ru> wrote:

> Hi.
> 
> The attached patch adds the
> module_param for video_nr to
> the gspca driver.
> The patch is completely untested
> as I don't use any webcam myself.
> Its just that a friend of mine
> complained about an inability to
> set the device number for gspca
> and I hope this patch can solve
> that problem.
> 
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>




Cheers,
Mauro
