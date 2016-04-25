Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52447 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbcDYLFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 07:05:08 -0400
Date: Mon, 25 Apr 2016 08:05:02 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.7] Various fixes, remove most 'experimental'
 annotations
Message-ID: <20160425080502.79c6bab4@recife.lan>
In-Reply-To: <571DDFF3.7050004@xs4all.nl>
References: <571DDFF3.7050004@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Apr 2016 11:14:27 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Here are various fixes for 4.7.
> 
> Note that I chose to go with my tw686x patches instead of yours
> (https://patchwork.linuxtv.org/patch/33991/).

Your patch caused this new smatch warning:
	drivers/media/pci/tw686x/tw686x-video.c:67 tw686x_fields_map() error: buffer overflow 'std_625_50' 26 <= 30

It sounds better to stay with the one I wrote ;)

For now, I'll just drop it from the patch series.

Regards,
Mauro
-- 
Thanks,
Mauro
