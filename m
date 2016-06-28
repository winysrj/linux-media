Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34135 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbcF1L7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 07:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <20160628083238.5fe7e32b@recife.lan>
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1462975376-491-4-git-send-email-ulrich.hecht+renesas@gmail.com> <20160628083238.5fe7e32b@recife.lan>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Jun 2016 13:59:22 +0200
Message-ID: <CAMuHMdUWjTe53bR-u39vn_TKjdWiB5UwO+jJmmk3_u-fe94Jgw@mail.gmail.com>
Subject: Re: [PATCH v4 3/8] media: rcar_vin: Use correct pad number in try_fmt
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ian Molton <ian.molton@codethink.co.uk>,
	Lars-Peter Clausen <lars@metafoo.de>,
	William Towle <william.towle@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Jun 28, 2016 at 1:32 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Wed, 11 May 2016 16:02:51 +0200
> Ulrich Hecht <ulrich.hecht+renesas@gmail.com> escreveu:
>
>> Fix rcar_vin_try_fmt's use of an inappropriate pad number when calling
>> the subdev set_fmt function - for the ADV7612, IDs should be non-zero.
>>
>> Signed-off-by: William Towle <william.towle@codethink.co.uk>
>> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>> [uli: adapted to rcar-vin rewrite]
>
> Please use [email@domain: some revierwer note], as stated at Documentation/SubmittingPatches.

"While there is nothing mandatory about this, it
 seems like prepending the description with your mail and/or name, all
 enclosed in square brackets, is noticeable enough to make it obvious that
 you are responsible for last-minute changes."

Hence a name should be sufficient.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
