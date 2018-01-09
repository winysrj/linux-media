Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:42484 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933760AbeAICLS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 21:11:18 -0500
Received: by mail-oi0-f67.google.com with SMTP id o64so9567958oia.9
        for <linux-media@vger.kernel.org>; Mon, 08 Jan 2018 18:11:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8223870.kpF3YQejF4@avalon>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151520103240.32271.14706852449205864676.stgit@dwillia2-desk3.amr.corp.intel.com>
 <8223870.kpF3YQejF4@avalon>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 Jan 2018 18:11:17 -0800
Message-ID: <CAPcyv4jn3O-qLKMgpTj0M+U98rO6M09p2XCxQggVVtWnAGBnYQ@mail.gmail.com>
Subject: Re: [PATCH 07/18] [media] uvcvideo: prevent bounds-check bypass via
 speculative execution
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Netdev <netdev@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Elena Reshetova <elena.reshetova@intel.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 8, 2018 at 3:23 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Dan,
>
> Thank you for the patch.
>
> On Saturday, 6 January 2018 03:10:32 EET Dan Williams wrote:
>> Static analysis reports that 'index' may be a user controlled value that
>> is used as a data dependency to read 'pin' from the
>> 'selector->baSourceID' array. In order to avoid potential leaks of
>> kernel memory values, block speculative execution of the instruction
>> stream that could issue reads based on an invalid value of 'pin'.
>
> I won't repeat the arguments already made in the thread regarding having
> documented coverity rules for this, even if I agree with them.
>
>> Based on an original patch by Elena Reshetova.
>>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: linux-media@vger.kernel.org
>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/media/usb/uvc/uvc_v4l2.c |    7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
>> b/drivers/media/usb/uvc/uvc_v4l2.c index 3e7e283a44a8..7442626dc20e 100644
>> --- a/drivers/media/usb/uvc/uvc_v4l2.c
>> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/wait.h>
>>  #include <linux/atomic.h>
>> +#include <linux/compiler.h>
>>
>>  #include <media/v4l2-common.h>
>>  #include <media/v4l2-ctrls.h>
>> @@ -810,6 +811,7 @@ static int uvc_ioctl_enum_input(struct file *file, void
>> *fh, struct uvc_entity *iterm = NULL;
>>       u32 index = input->index;
>>       int pin = 0;
>> +     __u8 *elem;
>>
>>       if (selector == NULL ||
>>           (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
>> @@ -820,8 +822,9 @@ static int uvc_ioctl_enum_input(struct file *file, void
>> *fh, break;
>>               }
>>               pin = iterm->id;
>> -     } else if (index < selector->bNrInPins) {
>> -             pin = selector->baSourceID[index];
>> +     } else if ((elem = nospec_array_ptr(selector->baSourceID, index,
>> +                                     selector->bNrInPins))) {
>> +             pin = *elem;
>>               list_for_each_entry(iterm, &chain->entities, chain) {
>>                       if (!UVC_ENTITY_IS_ITERM(iterm))
>>                               continue;
>
> (adding a bit more context)
>
>>                       if (iterm->id == pin)
>>                               break;
>>               }
>>       }
>>
>>       if (iterm == NULL || iterm->id != pin)
>>               return -EINVAL;
>>
>>       memset(input, 0, sizeof(*input));
>>       input->index = index;
>>       strlcpy(input->name, iterm->name, sizeof(input->name));
>>       if (UVC_ENTITY_TYPE(iterm) == UVC_ITT_CAMERA)
>>               input->type = V4L2_INPUT_TYPE_CAMERA;
>
> So pin is used to search for an entry in the chain->entities list. Entries in
> that list are allocated separately through kmalloc and can thus end up in
> different cache lines, so I agree we have an issue. However, this is mitigated
> by the fact that typical UVC devices have a handful (sometimes up to a dozen)
> entities, so an attacker would only be able to read memory values that are
> equal to the entity IDs used by the device. Entity IDs can be freely allocated
> but typically count continuously from 0. It would take a specially-crafted UVC
> device to be able to read all memory.
>
> On the other hand, as this is nowhere close to being a fast path, I think we
> can close this potential hole as proposed in the patch. So,
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks Laurent!

> Will you merge the whole series in one go, or would you like me to take the
> patch in my tree ? In the latter case I'll wait until the nospec_array_ptr()
> gets merged in mainline.

I'll track it for now. Until the 'nospec_array_ptr()' discussion
resolves there won't be a stabilized commit-id for you to base a
branch.
