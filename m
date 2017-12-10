Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:40424 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbdLJRda (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Dec 2017 12:33:30 -0500
MIME-Version: 1.0
In-Reply-To: <20171207133522.yqgb532ftcgvw62d@valkosipuli.retiisi.org.uk>
References: <1512579122-5215-1-git-send-email-pravin.shedge4linux@gmail.com> <20171207133522.yqgb532ftcgvw62d@valkosipuli.retiisi.org.uk>
From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Date: Sun, 10 Dec 2017 23:03:29 +0530
Message-ID: <CALSsfOC-mEzDbXZyO2iE-zedp8Fpb6DipWEbLogWcFKhHRG=aA@mail.gmail.com>
Subject: Re: [PATCH 09/45] drivers: media: remove duplicate includes
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 7, 2017 at 7:05 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Pravin,
>
> On Wed, Dec 06, 2017 at 10:22:02PM +0530, Pravin Shedge wrote:
>> These duplicate includes have been found with scripts/checkincludes.pl but
>> they have been removed manually to avoid removing false positives.
>>
>> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
>
> While at it, how about ordering the headers alphabetically as well? Having
> such a large number of headers there unordered may well be the reason why
> they're included more than once...
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi


Hi Sakari,

Sorry for the late reply.

Ordering the header files alphabetically helps to avoid problems such
as inclusion of duplicate header files.
My personal preference is to go from local to global, each subsection
in alphabetical order.
Ideally, all header files should be self-contained, and inclusion
order should not matter.
Simple reordering the headers should not break build.

Reordering header files aways helpful for big projects like Linux-Kernel.
But this requires changes tree wide and modifies lots of files.
Such change requires huge audience to be participated in discussion &
take a final call.

With this patch I just handled inclusion of header file multiple times
to avoid code duplication after preprocessing.

Thanks & Regards,
   PraviN
