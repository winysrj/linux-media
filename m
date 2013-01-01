Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab3AANNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 08:13:17 -0500
Date: Tue, 1 Jan 2013 11:12:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alexandre Lissy <lissyx+mozfr@lissyx.dyndns.org>
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	Alexandre LISSY <alexandrelissy@free.fr>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@wilsonet.com>
Subject: Re: iMon Knob driver issue
Message-ID: <20130101111242.051a352e@redhat.com>
In-Reply-To: <50DEE9C5.7020407@lissyx.dyndns.org>
References: <5081109E.7060809@free.fr>
	<50DEDD43.3080300@free.fr>
	<CALW4P+++ZZXAGkn+jRVi2D4iz_UpUVUQLFDoQGGfAUMmgUhntg@mail.gmail.com>
	<50DEE9C5.7020407@lissyx.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Dec 2012 14:01:57 +0100
Alexandre Lissy <lissyx+mozfr@lissyx.dyndns.org> escreveu:

> From cca7718a9902a4d5cffbf158b5853980a08ef930 Mon Sep 17 00:00:00 2001
> From: Alexandre Lissy <alexandrelissy@free.fr>
> Date: Sun, 2 Sep 2012 20:35:20 +0200
> Subject: [PATCH] fix: iMon Knob event interpretation issues
> 
> Events for the iMon Knob pad where not correctly interpreted, resulting
> in buggy mouse movements (cursor going straight out of the screen), key
> pad only generating KEY_RIGHT and KEY_DOWN events. A reproducer is:
> 
> int main(int argc, char ** argv)
> {
>         char rel_x = 0x00; printf("rel_x:%d @%s:%d\n", rel_x, __FILE__, __LINE__);
>         rel_x = 0x0f; printf("rel_x:%d @%s:%d\n", rel_x, __FILE__, __LINE__);
>         rel_x |= ~0x0f; printf("rel_x:%d @%s:%d\n", rel_x, __FILE__, __LINE__);
> 
>         return 0;
> }
> 
> (running on x86 or amd64)
> $ ./test
> rel_x:0 @test.c:6
> rel_x:15 @test.c:7
> rel_x:-1 @test.c:8
> 
> (running on armv6)
> rel_x:0 @test.c:6
> rel_x:15 @test.c:7
> rel_x:255 @test.c:8
> 
> Forcing the rel_x and rel_y variables as signed char fixes the issue.
> 
> Signed-off-by: Alexandre Lissy <alexandrelissy@free.fr>
> ---
>  drivers/media/rc/imon.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
> index 5dd0386..9d30ca9 100644
> --- a/drivers/media/rc/imon.c
> +++ b/drivers/media/rc/imon.c
> @@ -1225,7 +1225,7 @@ static u32 imon_panel_key_lookup(u64 code)
>  static bool imon_mouse_event(struct imon_context *ictx,
>  			     unsigned char *buf, int len)
>  {
> -	char rel_x = 0x00, rel_y = 0x00;
> +	signed char rel_x = 0x00, rel_y = 0x00;

(c/c Jarod, as he is the maintainer of this driver)

That looks weird, as, AFAIKT "char" is signed. Are you sure that this fix
is correct?

If so, maybe this could be a gcc-version-specific bug. What gcc version are
you using?

Btw, we generally use "s8" type for signed 8bit integers inside the Kernel.

>  	u8 right_shift = 1;
>  	bool mouse_input = true;
>  	int dir = 0;
> @@ -1301,7 +1301,7 @@ static void imon_touch_event(struct imon_context *ictx, unsigned char *buf)
>  static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
>  {
>  	int dir = 0;
> -	char rel_x = 0x00, rel_y = 0x00;
> +	signed char rel_x = 0x00, rel_y = 0x00;
>  	u16 timeout, threshold;
>  	u32 scancode = KEY_RESERVED;
>  	unsigned long flags;

-- 

Cheers,
Mauro
