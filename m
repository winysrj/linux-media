Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58666 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0IJI0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 04:26:53 -0400
Received: by iwn5 with SMTP id 5so1965447iwn.19
        for <linux-media@vger.kernel.org>; Fri, 10 Sep 2010 01:26:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009101022.22832.hverkuil@xs4all.nl>
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
	<4C89B3AD.1010404@redhat.com>
	<4C89E084.6090203@samsung.com>
	<201009101022.22832.hverkuil@xs4all.nl>
Date: Fri, 10 Sep 2010 04:26:52 -0400
Message-ID: <AANLkTi=uqW4tiCqeoub2BH-SEgVOmQb_U3nrcP4crrNf@mail.gmail.com>
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	t.fujak@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, Sep 10, 2010 at 4:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> It's been a long standing wish to convert the ivtv and cx18 drivers to videobuf,
> but it's always been too complex. With a new vb2 implementation it may become
> actually possible.

FYI:  KernelLabs has done a port of cx18 to videobuf.  We just haven't
submitted it upstream yet.  I'm just mentioning this so nobody else
feels the urge to take a crack at it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
