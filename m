Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33637 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbcAFROz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 12:14:55 -0500
Received: by mail-wm0-f50.google.com with SMTP id f206so67562684wmf.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jan 2016 09:14:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160106163427.GV9938@ZenIV.linux.org.uk>
References: <20151213003201.GQ20997@ZenIV.linux.org.uk> <CA+V-a8v-NC9oToS5KcaGwuATAxvOaXE3p=uT769uaKoebBVeBg@mail.gmail.com>
 <20160106163427.GV9938@ZenIV.linux.org.uk>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 6 Jan 2016 17:14:24 +0000
Message-ID: <CA+V-a8tCRtLq6_KrGeXVLg09Lv3Dmk6tmRXZgqYp0P8yAGPpzg@mail.gmail.com>
Subject: Re: [PATCH][davinci] ccdc_update_raw_params() frees the wrong thing
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 6, 2016 at 4:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jan 05, 2016 at 05:37:06PM +0000, Lad, Prabhakar wrote:
>> On Sun, Dec 13, 2015 at 12:32 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >         Passing a physical address to free_pages() is a bad idea.
>> > config_params->fault_pxl.fpc_table_addr is set to virt_to_phys()
>> > of __get_free_pages() return value; what we should pass to free_pages()
>> > is its phys_to_virt().  ccdc_close() does that properly, but
>> > ccdc_update_raw_params() doesn't.
>> >
>> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>> >
>> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> Regards,
>> --Prabhakar Lad
>
>         Which tree should it go through?  I can certainly put that into
> vfs.git#work.misc, but it looks like a better fit for linux-media tree, or
> the davinci-specific one...

It needs to go linux-media tree I'll issue a pull to mauro soon.

Cheers,
--Prabhakar Lad
