Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36494 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1762070AbdLSK5D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 05:57:03 -0500
Date: Tue, 19 Dec 2017 12:57:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/45] drivers: media: remove duplicate includes
Message-ID: <20171219105700.nksok5c5lujcoo7j@valkosipuli.retiisi.org.uk>
References: <1512579122-5215-1-git-send-email-pravin.shedge4linux@gmail.com>
 <20171207133522.yqgb532ftcgvw62d@valkosipuli.retiisi.org.uk>
 <CALSsfOC-mEzDbXZyO2iE-zedp8Fpb6DipWEbLogWcFKhHRG=aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALSsfOC-mEzDbXZyO2iE-zedp8Fpb6DipWEbLogWcFKhHRG=aA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 10, 2017 at 11:03:29PM +0530, Pravin Shedge wrote:
> On Thu, Dec 7, 2017 at 7:05 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Pravin,
> >
> > On Wed, Dec 06, 2017 at 10:22:02PM +0530, Pravin Shedge wrote:
> >> These duplicate includes have been found with scripts/checkincludes.pl but
> >> they have been removed manually to avoid removing false positives.
> >>
> >> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
> >
> > While at it, how about ordering the headers alphabetically as well? Having
> > such a large number of headers there unordered may well be the reason why
> > they're included more than once...
> >
> > --
> > Sakari Ailus
> > e-mail: sakari.ailus@iki.fi
> 
> 
> Hi Sakari,
> 
> Sorry for the late reply.
> 
> Ordering the header files alphabetically helps to avoid problems such
> as inclusion of duplicate header files.
> My personal preference is to go from local to global, each subsection
> in alphabetical order.
> Ideally, all header files should be self-contained, and inclusion
> order should not matter.
> Simple reordering the headers should not break build.
> 
> Reordering header files aways helpful for big projects like Linux-Kernel.
> But this requires changes tree wide and modifies lots of files.
> Such change requires huge audience to be participated in discussion &
> take a final call.

Hmm. I'm not quite sure what do you mean. You're already changing the three
files, there's no need to arrange others at the same time.

> 
> With this patch I just handled inclusion of header file multiple times
> to avoid code duplication after preprocessing.
> 
> Thanks & Regards,
>    PraviN

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
