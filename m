Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54662 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2BFHZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 02:25:00 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"'LMML'" <linux-media@vger.kernel.org>,
	"'dlos'" <davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [GIT PULL] davinci vpif pull request
Date: Mon, 6 Feb 2012 07:24:52 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753174D7F6@DBDE01.ent.ti.com>
References: <E99FAA59F8D8D34D8A118DD37F7C8F7531744F4D@DBDE01.ent.ti.com>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F7531744F4D@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
 A gentle reminder for the pull request.

Cheers,
-Manju

On Fri, Jan 27, 2012 at 15:43:00, Hadli, Manjunath wrote:
> Hi Mauro,
>  Can you please pull the following patch for v3.3-rc1 which removes some unnecessary inclusion  of machine specific header files from the main driver files?
> 
>  This patch has undergone sufficient review already. It is just a cleanup patch and I don't  expect any functionality to break because of this. 
> 
>  Thanks and Regards,
> -Manju
> 
> 
> The following changes since commit 74ea15d909b31158f9b63190a95b52bc05586d4b:
>   Linus Torvalds (1):
>         Merge branch 'v4l_for_linus' of git://git.kernel.org/.../mchehab/linux-media
> 
> 
> are available in the git repository at:
> 
> 
>   git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for-mauro-v3.3
> 
> Manjunath Hadli (1):
>       davinci: vpif: remove machine specific header file inclusion from the driver
> 
> 
>  drivers/media/video/davinci/vpif.h         |    2 --
>  drivers/media/video/davinci/vpif_display.c |    2 --
>  include/media/davinci/vpif_types.h         |    2 ++
>  3 files changed, 2 insertions(+), 4 deletions(-)
> 

