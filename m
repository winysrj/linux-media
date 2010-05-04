Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45455 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0EDN5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 09:57:51 -0400
Received: by wye20 with SMTP id 20so2369106wye.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 06:57:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100504113634.GT29093@bicker>
References: <20100504113634.GT29093@bicker>
Date: Tue, 4 May 2010 09:57:50 -0400
Message-ID: <o2mbe3a4a1005040657w9db5b9a6q16f4679d7e8cb56f@mail.gmail.com>
Subject: Re: [patch -next 3/3] media/IR/imon: potential double unlock on error
From: Jarod Wilson <jarod@wilsonet.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 4, 2010 at 7:36 AM, Dan Carpenter <error27@gmail.com> wrote:
> If there is an error here we should unlock in the caller (which is
> imon_init_intf1()).  We can remove this stray unlock.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Good catch, missed that when doing some heavy refactoring a while back
(haven't got a touch-capable device to have tripped over this either,
the cases with those in them are insanely expensive...)

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
