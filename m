Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33746 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbbLUOeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 09:34:15 -0500
Received: by mail-wm0-f51.google.com with SMTP id p187so70607214wmp.0
        for <linux-media@vger.kernel.org>; Mon, 21 Dec 2015 06:34:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHwmhgH=BsggjANy3K3UO2ACvys2HcsRNaU+sJTm9CAFdicGGA@mail.gmail.com>
References: <CAHwmhgFyjLOT6Na6oLXQT+FiUjyjrPX_CmKvQVDP-k9kawnMHw@mail.gmail.com>
	<CALF0-+UtHzo6-vYvUWtvS0hU7jyuPU+Ku4JC85T4gn4AHLgS0w@mail.gmail.com>
	<CAHwmhgGhdH8_+_5abeJZg=sL2nrr3psqzwHz3xrL_u1aV6mNCg@mail.gmail.com>
	<CAAEAJfDzpafBTqcTqjvEJWVxOQu7j=zK6m47VhnSVgM4kWhG5Q@mail.gmail.com>
	<CAHwmhgHsPZTLgChqO05NYv7h-rD_Sex2d+jqsK=PpYJxcHi78g@mail.gmail.com>
	<CAAEAJfCBBNC_Oj-pzVQWQV-hMFY99s+C6WdY+F+fDjjRBLk+qA@mail.gmail.com>
	<CAHwmhgEr_4thdArs3pNydpS-R2squ0ZV6g0cGcTg2Gg2OrmBSw@mail.gmail.com>
	<CAAEAJfCZ38DY8wx+vdqv=wVjDf+C6GD8ggR5cqKB9zVXOPKg_Q@mail.gmail.com>
	<CAHwmhgF-pYouHctHCy-d-uF4mDm-ZRd7kjJbxXRZ_9cKWG98fQ@mail.gmail.com>
	<CAAEAJfC2QuW9Dgg1Y50D=gMaE5qufZWhZLr7P2E389rWmTv8hg@mail.gmail.com>
	<CAHwmhgH=BsggjANy3K3UO2ACvys2HcsRNaU+sJTm9CAFdicGGA@mail.gmail.com>
Date: Mon, 21 Dec 2015 11:34:13 -0300
Message-ID: <CAAEAJfDXX9Kd=xaJG0YapTqoiScLdKn14n+AabTCrk7chZuTBQ@mail.gmail.com>
Subject: Re: Sabrent (stk1160) / Easycap driver problem
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Philippe Desrochers <desrochers.philippe@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,

On 20 December 2015 at 20:32, Philippe Desrochers
<desrochers.philippe@gmail.com> wrote:
> Hello Ezequiel,
>
> I tested with saa7115.c and the problem is in the "saa711x_detect_chip"
> function.
> In fact, the CJC7113 chip seems to returns all '1' when reading register 0.
>  ("1111111111111111" found @ 0x4a (stk1160)))
>
> I made a test by returning "SAA7113" without taking care of the value read
> from the CJC7113.
> By doing that, I was able to make the device work with VLC in Ubuntu 14.04.
>

That's good news, isn't it?

> I tried to find the datasheet of this CJC7113 chip but it does not seems to
> be available on the web.
>
> I will contact Sabrent for support and datasheet.
> If I get some positive response I think I will patch the driver otherwise I
> will select another dongle.
>

FWIW, I believe a patch to make CJC7113 detected as SAA7113 would
be acceptable.
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
