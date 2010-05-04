Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58305 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394Ab0EDNzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 09:55:12 -0400
Received: by wye20 with SMTP id 20so2366819wye.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 06:55:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100504113825.GV29093@bicker>
References: <20100504113825.GV29093@bicker>
Date: Tue, 4 May 2010 09:55:10 -0400
Message-ID: <i2rbe3a4a1005040655ied82f011gd2b9751aae5b5cdf@mail.gmail.com>
Subject: Re: [patch -next 2/3] media/IR/imon: testing the wrong variable
From: Jarod Wilson <jarod@wilsonet.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 4, 2010 at 7:38 AM, Dan Carpenter <error27@gmail.com> wrote:
> There is a typo here.  We meant to test "ir" instead of "props".  The
> "props" variable was tested earlier.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
