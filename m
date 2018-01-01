Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:38288 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeAAMmk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Jan 2018 07:42:40 -0500
Received: by mail-qk0-f178.google.com with SMTP id l19so24742412qke.5
        for <linux-media@vger.kernel.org>; Mon, 01 Jan 2018 04:42:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5fbb0600-82a0-5d17-a812-81d7707a335b@posteo.de>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
 <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
 <1513715821.7000.228.camel@linux.intel.com> <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
 <1513866211.7000.250.camel@linux.intel.com> <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
 <1514476996.7000.437.camel@linux.intel.com> <5fbb0600-82a0-5d17-a812-81d7707a335b@posteo.de>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 1 Jan 2018 14:42:38 +0200
Message-ID: <CAHp75VftepWFT55Lwt-ki4K1+-Dy0y-=SU+bQQ6SRqkvapPF-w@mail.gmail.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
To: Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 31, 2017 at 5:19 PM, Kristian Beilke <beilke@posteo.de> wrote:
> On 12/28/2017 05:03 PM, Andy Shevchenko wrote:
>> On Sat, 2017-12-23 at 01:31 +0100, Kristian Beilke wrote:
>>> On 12/21/2017 03:23 PM, Andy Shevchenko wrote:
>>>> On Thu, 2017-12-21 at 13:54 +0100, Kristian Beilke wrote:
>>>>> On Tue, Dec 19, 2017 at 10:37:01PM +0200, Andy Shevchenko wrote:
>>>>>> On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
>>>>>>> Cc Alan and Andy.
>>>>>>>
>>>>>>> On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke
>>>>>>> wrote:
>>>>>>>> Dear all,
>>>>>>>>
>>>>>>>> I am trying to get the cameras in a Lenovo IdeaPad Miix 320
>>>>>>>> (Atom
>>>>>>>> x5-Z8350 BayTrail) to work. The front camera is an ov2680.
>>>>>>>> With
>>>
>>> CherryTrail
>
>>>>>> WRT to the messages below it seems we have no platform data for
>>>>>> that
>>>>>> device. It needs to be added.
>>>>>>
>>>
>>> I tried to do exactly this. Extracted some values from
>>> acpidump/acpixtract and dmidecode, but unsure I nailed it.
>>
>> Can you share somewhere it (pastebin.com, gist.github.com, etc)?
>>
>
> https://gist.github.com/jdkbx/dabe0d000330dd2a04acf8d870e0e06f
>
> dmidecode gives me
>
> Handle 0x0002, DMI type 2, 17 bytes
> Base Board Information
>         Manufacturer: LENOVO
>         Product Name: LNVNB161216
>         Version: SDK0J91196WIN
>
> what I assume works as identifier in:
> DMI_MATCH(DMI_BOARD_NAME, "LNVNB161216")
>
> diff --git
> a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> index 87216bc35648..716be4ace60e 100644
> ---
> a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> +++
> b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> @@ -503,6 +503,18 @@ static struct gmin_cfg_var cht_cr_vars[] = {
>         {},
>  };
>
> +static struct gmin_cfg_var miix320_vars[] = {
> +        {"OVTI2680:00_CamType", "1"},
> +        {"OVTI2680:00_CsiPort", "0"},
> +        {"OVTI2680:00_CsiLanes", "1"},
> +        {"OVTI2680:00_CsiFmt", "15"},
> +        {"OVTI2680:00_CsiBayer", "0"},
> +        {"OVTI2680:00_CamClk", "1"},
> +        {"OVTI2680:00_Regulator1p8v", "0"},
> +        {"OVTI2680:00_Regulator2p8v", "0"},
> +        {},
> +};
> +
>  static struct gmin_cfg_var mrd7_vars[] = {
>         {"INT33F8:00_CamType", "1"},
>         {"INT33F8:00_CsiPort", "1"},
> @@ -566,6 +578,13 @@ static const struct dmi_system_id gmin_vars[] = {
>                 },
>                 .driver_data = cht_cr_vars,
>                 },
> +       {
> +                .ident = "MIIX320",
> +                .matches = {
> +                        DMI_MATCH(DMI_BOARD_NAME, "LNVNB161216"),
> +                },
> +                .driver_data = miix320_vars,
> +        },
>         {
>                 .ident = "MRD7",
>                 .matches = {
>
>>> After your set of patches I applied the CherryTrail support I found
>>> here
>>> https://github.com/croutor/atomisp2401

Hmm... Missed this URL.

Patch 0003-atomisp_gmin_platform-tweak-to-drive-axp288.patch gives a
little confusion.
The PMIC driver should work via ACPI OpRegion macro (and should be
enabled in kernel configuration). That's how it supposed to work.
The patch seems redundant.

Anyway, nice finding, I guess we need to include Vincent to this discussion.

>> Second, apply

>> Third, you need to change pmic_id to be PMIC_AXP (I have longer patch
>> for this, that's why don't post here). Just hard code it for now in gmin
>> file.

> I assume the given patch set does already what you suggest here, apart
> from the DDEBUG DEFINE.

No, those are completely ugly hacks to prevent driver fail on probing.

>> Fourth, you have to be sure the clock rate is chosen correctly
>> (currently there is a bug in clk_set_rate() where parameter is clock
>> source index instead of frequency!). I think you need to hardcode
>> 19200000 there instead of gs->clock_src.
>
> I found nothing about this in the patch set, so I will do this manually.

Yep, there is none in the wild to address this issue.

>> You are expecting /dev/video<N> nodes. /dev/camera is usually a udev's
>> alias against one of /dev/video<N> nodes.
>
> As described by Alan in a later mail, this actually gives me 10
> /dev/video[0-10] nodes, but none producing any images. video4 and
> video10 cause a kernel oops when opened.

The most interesting one is /dev/video0 (capture, i.e. photo).

>>>  Am I on the right track here, or am
>>> I wasting my (and your) time?

>> It's both: track is right and it's waste of time.

> I see your point, Still it feels, as if this could go somewhere.

I hope so, though I didn't try CherryTrail and according to Alan that
is what he had tried on.

>  Anyway,
> thanks for your explanations and the time you invested into this.

You are welcome!

-- 
With Best Regards,
Andy Shevchenko
