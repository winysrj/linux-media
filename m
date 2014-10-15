Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43010 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaJOJmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Oct 2014 05:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWZ=G+oHMWLQasHXeCxVnYQkQ81owKBMiyfnjzgigUPYQ@mail.gmail.com>
References: <1413268013-8437-1-git-send-email-ykaneko0929@gmail.com>
	<1413268013-8437-2-git-send-email-ykaneko0929@gmail.com>
	<CAMuHMdWZ=G+oHMWLQasHXeCxVnYQkQ81owKBMiyfnjzgigUPYQ@mail.gmail.com>
Date: Wed, 15 Oct 2014 18:42:41 +0900
Message-ID: <CAH1o70Ko8d5xd6C-2oaSx7nMBvNNDtQ3dj-rKV_KPPUkri6wqA@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: soc_camera: rcar_vin: Add scaling support
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Geert,

Thanks for your comment.
I'll update this patch.

Thanks,
Kaneko

2014-10-15 4:25 GMT+09:00 Geert Uytterhoeven <geert@linux-m68k.org>:
> Hi Kaneko-san, Matsuoka-san,
>
> On Tue, Oct 14, 2014 at 8:26 AM, Yoshihiro Kaneko <ykaneko0929@gmail.com> wrote:
>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>
> Thanks for our patch!
>
>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>
>> @@ -120,6 +144,326 @@ enum chip_id {
>>         RCAR_E1,
>>  };
>>
>> +struct VIN_COEFF {
>
> Please don't use upper case for struct names.
>
>> +       unsigned short xs_value;
>> +       unsigned long coeff_set[24];
>
> The actual size of "long" depends on the word size of the CPU.
> On 32-bit builds it is 32-bit, on 64-bit builds it is 64-bit.
> As all values in the table below are 32-bit, and the values are
> written to register using iowrite32(), please use "u32" instead of
> "unsigned long".
>
>> +};
>
>> +#define VIN_COEFF_SET_COUNT (sizeof(vin_coeff_set) / sizeof(struct VIN_COEFF))
>
> There exists a convenience macro "ARRAY_SIZE()" for this.
> Please just use "ARRAY_SIZE(vin_coeff_set)" instead of defining
> "VIN_COEFF_SET_COUNT".
>
>> @@ -677,6 +1024,61 @@ static void rcar_vin_clock_stop(struct soc_camera_host *ici)
>>         /* VIN does not have "mclk" */
>>  }
>>
>> +static void set_coeff(struct rcar_vin_priv *priv, unsigned long xs)
>
> I think xs can be "unsigned short"?
>
>> +{
>> +       int i;
>> +       struct VIN_COEFF *p_prev_set = NULL;
>> +       struct VIN_COEFF *p_set = NULL;
>
> If you add "const" to the two definitions above...
>
>> +       /* Search the correspondence coefficient values */
>> +       for (i = 0; i < VIN_COEFF_SET_COUNT; i++) {
>> +               p_prev_set = p_set;
>> +               p_set = (struct VIN_COEFF *) &vin_coeff_set[i];
>
> ... the above cast is no longer needed.
>
>> @@ -686,6 +1088,7 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
>>         unsigned int left_offset, top_offset;
>>         unsigned char dsize = 0;
>>         struct v4l2_rect *cam_subrect = &cam->subrect;
>> +       unsigned long value;
>
> "u32", as it's written to a 32-bit register later.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
