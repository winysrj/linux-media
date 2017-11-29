Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44586 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751673AbdK2MZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 07:25:08 -0500
Date: Wed, 29 Nov 2017 10:24:57 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Georgiana Chelu <georgiana.chelu93@gmail.com>,
        simran singhal <singhalsimran0@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Hans de Goede <hdegoede@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guru Das Srinagesh <gurooodas@gmail.com>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Paolo Cretaro <melko@frugalware.org>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?B?SsOpcsOp?= =?UTF-8?B?bXk=?= Lefaure
        <jeremy.lefaure@lse.epita.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shy More <smklearn@gmail.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Srishti Sharma <srishtishar@gmail.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/7] media: atomisp: stop producing hundreds of
 kernel-doc warnings
Message-ID: <20171129102457.4b41091c@recife.lan>
In-Reply-To: <20171129121453.i2qmuwxzcajgx5ev@paasikivi.fi.intel.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
        <20171129121453.i2qmuwxzcajgx5ev@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Nov 2017 14:14:54 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> Thanks for the patch.
> 
> On Wed, Nov 29, 2017 at 07:08:04AM -0500, Mauro Carvalho Chehab wrote:
> > A recent change on Kernel 4.15-rc1 causes all tags with
> > /** to be handled as kernel-doc markups. Well, several
> > atomisp modules, it doesn't use kernel-doc, but some other
> > documentation markup (doxygen?).
> > 
> > So, suppress all those warns by replacing /** by /*.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> I presume you haven't written the patch manually. There are other changes
> that described by the comment, too, such as removing lesser
> than-characaters.
> 
> It'd be good to mention how it's been generated.

Yeah, I used a simple script, and manually fixed a few minor things
that were still causing warnings.

The core changes were done via:

	for i in $(find drivers/staging/media/atomisp -type f); do sed 's,/\*\* ,/\*, ' -i $i; done
	for i in $(find drivers/staging/media/atomisp -type f); do sed 's,/\*\*<,/\**,' -i $i; done
	for i in drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c; do perl -ne 's,\/\*\*$,/*,g; print $_'  $i > a && mv a $i; done;

I'll add it at the patch description.

Thanks,
Mauro
