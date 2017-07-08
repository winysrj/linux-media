Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:34682 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdGHNb5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Jul 2017 09:31:57 -0400
Received: by mail-wr0-f182.google.com with SMTP id 77so81184583wrb.1
        for <linux-media@vger.kernel.org>; Sat, 08 Jul 2017 06:31:56 -0700 (PDT)
Subject: Re: [PATCH v6] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20170623203456.503714406@cogentembedded.com>
 <589c2ca4-d1e7-86c3-1ef5-8831a54856ed@xs4all.nl>
 <45854c21-f355-37e4-b677-dddb8222e719@cogentembedded.com>
From: Konstantin Kozhevnikov <konstantin.kozhevnikov@cogentembedded.com>
Message-ID: <bb62b320-262b-0cc4-7da3-5b2c7f9c7535@cogentembedded.com>
Date: Sat, 8 Jul 2017 16:31:44 +0300
MIME-Version: 1.0
In-Reply-To: <45854c21-f355-37e4-b677-dddb8222e719@cogentembedded.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

the sample is made publicly available, and can be taken from 
https://github.com/CogentEmbedded/imr-sv-utest/blob/master/utest/utest-imr.c.

It doesn't show how luminance/chrominance correction actually works, 
however. That feature has been tested once a while ago, and probably we 
are going to release that soon.

Regarding usage of "chromacity" word in the comments, I actually meant 
"chrominance" or "chroma". The difference for non-native speaker is 
probably a bit vague, just like one between "luminance" and 
"luminosity". In the R-Car manual it is referred to as "hue", but what 
is meant is the "luma" and "chroma". These short forms seem a bit weird 
to me, hence I was using the words "luminance" and "chromacity". If 
that's confusing, I don't mind them be replaced with just "luma"/"chroma".

For documentation part, I am not 100% sure Renesas is okay with 
disclosing each and every detail, it might be the case we should obtain 
a permit from their legals. Still, I believe the person who is about to 
use the driver is having an access to at least Technical Reference 
Manual of R-Car Gen2/3, so adding a reference to a chapter in TRM will 
most likely be sufficient.

The question about usage of "user-pointer" buffers (V4L2_MEMORY_USERPTR) 
is a bit confusing. Indeed, right now we are using that scheme, though I 
wouldn't say we are absolutely required to do that. Specifically, we are 
allocating the contiguous buffers using Renesas' proprietary "mmngr" 
driver (it's not a rocket science thing, but it's made proprietary for 
some reason). Then we are using the buffers for various persons, both in 
EGL and in IMR. I guess we are okay with moving completely to DMA-fd 
(given the fact we have an accompanying driver "mmngrbuf" which serves 
for translation of memory pointers to DMA-fds for further cross-process 
sharing and stuff). I mean, if USERPTR is tagged as an obsolete / 
deprecated function, we are fine with dropping it. However, there is one 
thing I'd like to understand from V4L2 experts. I do see sometimes 
(during application closing or shortly after it) the bunches of warnings 
from kernel regarding "corrupted" MMU state (don't recall exactly, but 
it sounds like page which is supposed to be free gets somehow 
corrupted). Is that something that is related to (mis)use of USERPTR? I 
was trying to find out if there is any memory corruption caused by 
application logic, came to conclusion it's not. To me it looks like a 
race condition between unmapping of VMAs and V4L2 buffers deallocation 
which yields sometimes unpredictable results. Can you please provide 
some details about possible issues with usage of USERPTR with 
DMA-contiguous buffer driver, it would be good to find a match.

(Sorry, it got pretty long)

Sincerely,
Kostya

On 06/07/17 21:16, Sergei Shtylyov wrote:
> Hello!
>
> On 07/03/2017 03:43 PM, Hans Verkuil wrote:
>
>>> Index: media_tree/Documentation/media/v4l-drivers/rcar_imr.rst
>>> ===================================================================
>>> --- /dev/null
>>> +++ media_tree/Documentation/media/v4l-drivers/rcar_imr.rst
>>> @@ -0,0 +1,86 @@
>>> +Renesas R-Car Image Rendeder (IMR) Driver
>>
>> Rendeder -> Renderer
>
>    Oops, sorry. :-)
>
>>> +=========================================
>>> +
>>> +This file documents some driver-specific aspects of the IMR driver, 
>>> such as
>>> +driver-specific ioctls.
>>> +
>>> +The ioctl reference
>>> +~~~~~~~~~~~~~~~~~~~
>>> +
>>> +VIDIOC_IMR_MESH - Set mapping data
>>> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> +
>>> +Argument: struct imr_map_desc
>>> +
>>> +**Description**:
>>> +
>>> +    This ioctl sets up the mesh using which the input frames will be
>>
>> s/using/through/
>>
>>> +    transformed into the output frames. The mesh can be strictly 
>>> rectangular
>>> +    (when IMR_MAP_MESH bit is set in imr_map_desc::type) or 
>>> arbitrary (when
>>> +    that bit is not set).
>>> +
>>> +    A rectangular mesh consists of the imr_mesh structure followed 
>>> by M*N
>>> +    vertex objects (where M is imr_mesh::rows and N is 
>>> imr_mesh::columns).
>>> +    In case either IMR_MAP_AUTOSG or IMR_MAP_AUTODG bits were set in
>>> +    imr_map_desc::type, imr_mesh::{x|y}0 specify the coordinates of 
>>> the top
>>> +    left corner of the auto-generated mesh and imr_mesh::d{x|y} 
>>> specify the
>>> +    mesh's X/Y steps.
>>
>> What if any of the other types are used like IMR_MAP_LUCE?
>
>    IMR_MAP_LUCE only affects the vertex object.
>
>> Is this documented in a Renesas datasheet?
>
>    Yes.
>
>> If so, add a reference to that in this
>> documentation.
>
>    Unfortunately it's not publicly available.
>
>>> +
>>> +    An arbitrary mesh consists of the imr_vbo structure followed by N
>>> +    triangle objects (where N is imr_vbo::num), consisting of 3 vertex
>>> +    objects each.
>>> +
>>> +    A vertex object has a complex structure:
>>> +
>>> +.. code-block:: none
>>> +
>>> +    __u16    v        vertical   \ source coordinates (only present
>>> +    __u16    u        horizontal / if IMR_MAP_AUTOSG isn't set)
>>> +    __u16    Y        vertical   \ destination coordinates (only here
>>> +    __u16    X        horizontal / if IMR_MAP_AUTODG isn't set)
>>> +    __s8    lofst        offset \  luminance correction parameters
>>> +    __u8    lscal        scale   > (only present if IMR_MAP_LUCE
>>> +    __u16    reserved           /  is set)
>>> +    __s8    vrofs        V value offset \  hue correction parameters
>>> +    __u8    vrscl        V value scale   \ (only present if 
>>> IMR_MAP_CLCE
>>> +    __s8    ubofs        U value offset  / is set)
>>> +    __u8    ubscl        U value scale  /
>>
>> Is this the internal structure? Or something that userspace has to 
>> fill in?
>
>    Yes, the user space have to pass that to the driver which 
> constructs the display lists using these data.
>
>> It's not clear at all.
>>
>> I recommend giving a few code examples of how this should be used.
>
>    Konstantin, can we give some examples?
>
>>> +
>>> +**Return value**:
>>> +
>>> +    On success 0 is returned. On error -1 is returned and errno is set
>>> +    appropriately.
>>> +
>>> +**Data types**:
>>> +
>>> +.. code-block:: none
>>> +
>>> +    * struct imr_map_desc
>>> +
>>> +    __u32    type        mapping types
>>
>> This is a bitmask? If so, what combination of bits are allowed?
>
>    Yes, bitmask.
>
>>> +    __u32    size        total size of the mesh structure
>>> +    __u64    data        map-specific user-pointer
>>> +
>>> +    IMR_MAP_MESH        regular mesh specification
>>> +    IMR_MAP_AUTOSG        auto-generated source coordinates
>>> +    IMR_MAP_AUTODG        auto-generated destination coordinates
>>> +    IMR_MAP_LUCE        luminance correction flag
>>> +    IMR_MAP_CLCE        chromacity correction flag
>>
>> You probably mean 'chroma'. 'chromacity' isn't a word.
>
>    But it's recognized by all online translators I've tried. :-)
>
>>> +    IMR_MAP_TCM        vertex clockwise-mode order
>>> +    IMR_MAP_UVDPOR(n)    source coordinate decimal point position
>>> +    IMR_MAP_DDP        destination coordinate sub-pixel mode
>>> +    IMR_MAP_YLDPO(n)    luminance correction offset decimal point
>>> +                position
>>> +    IMR_MAP_UBDPO(n)    chromacity (U) correction offset decimal point
>>> +                position
>>> +    IMR_MAP_VRDPO(n)    chromacity (V) correction offset decimal point
>>> +                position
>>
>> There is no documentation what how these types relate to IMR_MAP_MESH 
>> and
>> IMR_MAP_AUTOS/DG.
>
>    They are basically orthogonal, IIRC.
>
>>> +
>>> +    * struct imr_mesh    regular mesh specification
>>> +
>>> +    __u16    rows, columns    rectangular mesh sizes
>>> +    __u16    x0, y0, dx, dy    auto-generated mesh parameters
>>> +
>>> +    * struct imr_vbo    vertex-buffer-object (VBO) descriptor
>>> +
>>> +    __u16    num        number of triangles
>>
>> Sorry, this needs more work.
>
>    Sigh, everybody hates writing docs, I guess... :-)
>
>> Regards,
>>
>>     Hans
>
> MBR, Sergei
>
