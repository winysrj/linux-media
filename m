Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1IZLTB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:19:01 -0400
Message-ID: <4E805FA1.6000208@redhat.com>
Date: Mon, 26 Sep 2011 08:18:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com> <4E7D5561.6080303@redhat.com> <010b01cc7c33$98a99a50$c9fccef0$%szyprowski@samsung.com>
In-Reply-To: <010b01cc7c33$98a99a50$c9fccef0$%szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-09-2011 07:03, Marek Szyprowski escreveu:
> Hello Mauro,
> 
> Ok, I agree that s5p-tv patches need some more work. What about
> the other patches, especially these two:
> "vb2: add vb2_get_unmapped_area in vb2 core"

Just reviewed this one.

> "v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev"? 

Applied, thanks.

> I cannot find them in your staging/for_v3.2 branch yet - should
> I include them in the next pull request?

I reserved some fun to work on this Monday morning ;)

Anyway, I've reviewed the remaining patches already.

Thanks,
Mauro
