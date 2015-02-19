Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:49988 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbbBSJo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 04:44:58 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1502182216060.31387@axis700.grange>
References: <1424277163-24869-1-git-send-email-geert+renesas@glider.be>
	<54E4D2DB.4050909@cogentembedded.com>
	<Pine.LNX.4.64.1502182216060.31387@axis700.grange>
Date: Thu, 19 Feb 2015 10:44:57 +0100
Message-ID: <CAMuHMdVQcRD6GNO57gP9FDzZDW0CSMtNAqoSfHcDeHAFeZ6Hwg@mail.gmail.com>
Subject: Re: [PATCH] [media] soc-camera: Remove bogus devm_kfree() in soc_of_bind()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Feb 18, 2015 at 10:16 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 18 Feb 2015, Sergei Shtylyov wrote:
>> On 02/18/2015 07:32 PM, Geert Uytterhoeven wrote:
>> > Unlike scan_async_group(), soc_of_bind() doesn't allocate its
>> > soc_camera_async_client structure using devm_kzalloc(), but has it
>> > embedded inside the soc_of_info structure.  Hence on failure, it must
>> > not free it using devm_kfree(), as this will cause a warning, and may
>> > cause slab corruption:
>>
>> [...]
>>
>> > Fixes: 1ddc6a6caa94e1e1 ("[media] soc_camera: add support for dt binding
>> > soc_camera drivers")
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> > ---
>> > Triggered with shmobile-defconfig on r8a7791/koelsch.
>> > ---
>> >   drivers/media/platform/soc_camera/soc_camera.c | 1 -
>> >   1 file changed, 1 deletion(-)
>>
>> > diff --git a/drivers/media/platform/soc_camera/soc_camera.c
>> > b/drivers/media/platform/soc_camera/soc_camera.c
>> > index cee7b56f84049944..d8a072fe46035821 100644
>> > --- a/drivers/media/platform/soc_camera/soc_camera.c
>> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
>> > @@ -1665,7 +1665,6 @@ eclkreg:
>> >   eaddpdev:
>> >     platform_device_put(sasc->pdev);
>> >   eallocpdev:
>> > -   devm_kfree(ici->v4l2_dev.dev, sasc);
>>
>>    Perhaps Ben meant 'info' ISO 'sasc'? This way it would make more sense.
>
> Agree. Geert, could you double-check and respin?

Sergei is right. Will update and resend.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
