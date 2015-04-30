Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33172 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbD3Loo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 07:44:44 -0400
MIME-Version: 1.0
In-Reply-To: <5542105A.1010601@cogentembedded.com>
References: <1430327133-8461-1-git-send-email-ykaneko0929@gmail.com>
	<5542105A.1010601@cogentembedded.com>
Date: Thu, 30 Apr 2015 13:44:43 +0200
Message-ID: <CAMuHMdVufCUC+kP-mHgZNLHsvCbMvTGzehdX3X9J9t1SPTQY=Q@mail.gmail.com>
Subject: Re: [PATCH/RFC] v4l: vsp1: Align crop rectangle to even boundary for
 YUV formats
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 30, 2015 at 1:22 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>> Since there is no distintion between 12bit and 16bit YUV formats in
>
>    Вistinсtion.

Distinction?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
