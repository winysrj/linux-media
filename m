Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57467 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab0JUPX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 11:23:56 -0400
Received: by gyb13 with SMTP id 13so528918gyb.19
        for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 08:23:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101021120745.44578b22@pedra>
References: <cover.1287669886.git.mchehab@redhat.com>
	<20101021120745.44578b22@pedra>
Date: Thu, 21 Oct 2010 11:23:55 -0400
Message-ID: <AANLkTi=3Hbn7NAWWGhHu7BS8nsJjdroEXXB+S4T4dYaN@mail.gmail.com>
Subject: Re: [PATCH 1/4] [media] cx231xx: Fix compilation breakage if DVB is
 not selected
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Oct 21, 2010 at 10:07 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> In file included from drivers/media/video/cx231xx/cx231xx-audio.c:40:
> drivers/media/video/cx231xx/cx231xx.h:559: error: field ‘frontends’ has incomplete type
> make[4]: ** [drivers/media/video/cx231xx/cx231xx-audio.o] Erro 1
> make[3]: ** [drivers/media/video/cx231xx] Erro 2
> make[2]: ** [drivers/media/video] Erro 2
> make[1]: ** [drivers/media] Erro 2
> make: ** [drivers] Erro 2
>
> Reported-by: Marcio Araujo Alves <froooozen@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
