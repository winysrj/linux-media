Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:45474 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeDRLOA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 07:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <20180418090801.uydntb4ruc7r472z@valkosipuli.retiisi.org.uk>
References: <20180417144305.GA31337@jordon-HP-15-Notebook-PC> <20180418090801.uydntb4ruc7r472z@valkosipuli.retiisi.org.uk>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Wed, 18 Apr 2018 16:43:58 +0530
Message-ID: <CAFqt6zYqLjhd=c62SL=dGxmdr8dyTRzfLcZ8D8z+he5hZCy82Q@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2-core: Change return type to vm_fault_t
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, jack@suse.cz,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 18, 2018 at 2:38 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Tue, Apr 17, 2018 at 08:13:06PM +0530, Souptick Joarder wrote:
>> Use new return type vm_fault_t for fault handler. For
>> now, this is just documenting that the function returns
>> a VM_FAULT value rather than an errno. Once all instances
>> are converted, vm_fault_t will become a distinct type.
>>
>> Reference id -> 1c8f422059ae ("mm: change return type to
>> vm_fault_t")
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>
> Subject should mention "videobuf"; videobuf is not part of V4L2 core
> (albeit the directory structure would certainly seem to suggest that). With
> that,
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Thanks. I will update the subject and send v2.
