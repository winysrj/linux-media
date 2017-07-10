Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34291 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdGJGW1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 02:22:27 -0400
MIME-Version: 1.0
In-Reply-To: <20170709195250.hu3psedjrvjkhivv@valkosipuli.retiisi.org.uk>
References: <20170707144521.4520-1-gehariprasath@gmail.com>
 <20170708110157.jkpg6foz35lckdqu@ihha.localdomain> <CAHHWPbfxGxJ6_N=rx1ZFW-DnTTAui0qYcbCjrY=ke3mGJF_kkA@mail.gmail.com>
 <20170709195250.hu3psedjrvjkhivv@valkosipuli.retiisi.org.uk>
From: hari prasath <gehariprasath@gmail.com>
Date: Mon, 10 Jul 2017 11:52:26 +0530
Message-ID: <CAHHWPbfobni1dCVR4771a+hkHyJO6s4GENeaj2XU_=un4mioFA@mail.gmail.com>
Subject: Re: [PATCH v2] staging: atomisp: use kstrdup to replace kmalloc and memcpy
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        SIMRAN SINGHAL <singhalsimran0@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 July 2017 at 01:22, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Sun, Jul 09, 2017 at 05:56:15PM +0530, hari prasath wrote:
>> On 8 July 2017 at 16:31, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> > Hi Hari,
>> >
>> > On Fri, Jul 07, 2017 at 08:15:21PM +0530, Hari Prasath wrote:
>> >> kstrdup kernel primitive can be used to replace kmalloc followed by
>> >> string copy. This was reported by coccinelle tool
>> >>
>> >> Signed-off-by: Hari Prasath <gehariprasath@gmail.com>
>> >> ---
>> >>  .../media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c       | 10 +++-------
>> >>  1 file changed, 3 insertions(+), 7 deletions(-)
>> >>
>> >> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
>> >> index 34cc56f..68db87b 100644
>> >> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
>> >> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
>> >> @@ -144,14 +144,10 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
>> >>       )
>> >>       {
>> >>               char *namebuffer;
>> >> -             int namelength = (int)strlen(name);
>> >> -
>> >> -             namebuffer = (char *) kmalloc(namelength + 1, GFP_KERNEL);
>> >> -             if (namebuffer == NULL)
>> >> -                     return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
>> >> -
>> >> -             memcpy(namebuffer, name, namelength + 1);
>> >>
>> >> +             namebuffer = kstrdup(name, GFP_KERNEL);
>> >> +             if (!namebuffer)
>> >> +                     return -ENOMEM;
>> >
>> > The patch also changes the return value in error cases. I believe the
>> > caller(s) expect to get errors in the IA_CCS_ERR_* range.
>>
>> Hi,
>>
>> In this particular case, the calling function just checks if it's not
>> success defined by a enum. I think returning -ENOMEM would not effect,
>> at least in this case.
>
> It might not, but the function now returns both negative Posix and positive
> CSS error codes. The CSS error codes could well be converted to Posix but
> it should be done consistently and preferrably in a separate patch.


Hi Sakari, Thanks for your comments. I will stick with just replacing
with kstrdup and retain the original error return value. I will send a
v3.

Regards,
Hari

>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk



-- 
Regards,
G.E.Hari Prasath
