Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:48965 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750993Ab2HGEnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 00:43:41 -0400
Message-ID: <501CA0B2.7010500@xenotime.net>
Date: Fri, 03 Aug 2012 21:10:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v3.6] edac: add a new per-dimm API and make
 the old per-virtual-rank API obsolete
References: <E1SxTx2-0003Gt-4b@www.linuxtv.org>
In-Reply-To: <E1SxTx2-0003Gt-4b@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/11/2012 09:23 AM, Mauro Carvalho Chehab wrote:

> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:


Wrong git tree ?????


> Subject: edac: add a new per-dimm API and make the old per-virtual-rank API obsolete
> Author:  Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:    Wed Mar 21 17:06:53 2012 -0300
> 
> The old EDAC API is broken. It only works fine for systems manufatured
> before 2005 and for AMD 64. The reason is that it forces all memory
> controller drivers to discover rank info.
> 
> Also, it doesn't allow grouping the several ranks into a DIMM.
> 
> So, what almost all modern drivers do is to create a fake virtual-rank
> information, and use it to cheat the EDAC core to accept the driver.
> 
> While this works if the user has enough time to discover what DIMM slot
> corresponds to each "virtual-rank" information, it prevents EDAC usage
> for users with less available time. It also makes life hard for vendors
> that may want to provide a table with their motherboards to the userspace
> tool (edac-utils) as each driver has its own logic for the virtual
> mapping.
> 
> So, the old API should be removed, in favor of a more flexible API that
> allows newer drivers to not lie to the EDAC core.
> 
> Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
> Cc: Doug Thompson <norsk5@yahoo.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: Hui Wang <jason77.wang@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/edac/Kconfig         |    8 ++
>  drivers/edac/edac_mc_sysfs.c |  165 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 172 insertions(+), 1 deletions(-)
> 
> ---


-- 
~Randy
