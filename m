Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:45210 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750713AbdK2MPC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 07:15:02 -0500
Date: Wed, 29 Nov 2017 14:14:54 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
        =?iso-8859-1?B?Suly6W15?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shy More <smklearn@gmail.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Srishti Sharma <srishtishar@gmail.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/7] media: atomisp: stop producing hundreds of
 kernel-doc warnings
Message-ID: <20171129121453.i2qmuwxzcajgx5ev@paasikivi.fi.intel.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

On Wed, Nov 29, 2017 at 07:08:04AM -0500, Mauro Carvalho Chehab wrote:
> A recent change on Kernel 4.15-rc1 causes all tags with
> /** to be handled as kernel-doc markups. Well, several
> atomisp modules, it doesn't use kernel-doc, but some other
> documentation markup (doxygen?).
> 
> So, suppress all those warns by replacing /** by /*.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I presume you haven't written the patch manually. There are other changes
that described by the comment, too, such as removing lesser
than-characaters.

It'd be good to mention how it's been generated.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
