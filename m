Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63705 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeAWMkV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 07:40:21 -0500
Date: Tue, 23 Jan 2018 10:40:13 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.16] CIO2 compiler warning fix
Message-ID: <20180123104008.25ebdef5@vela.lan>
In-Reply-To: <20180109223517.lkj4opdpm64jpf5d@valkosipuli.retiisi.org.uk>
References: <20180109223517.lkj4opdpm64jpf5d@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Jan 2018 00:35:18 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Here's compile warning fix for the Intel IPU3 CIO2 driver from Arnd.
> 
> Please pull.
> 
> 
> The following changes since commit e3ee691dbf24096ea51b3200946b11d68ce75361:
> 
>   media: ov5640: add support of RGB565 and YUYV formats (2018-01-05 12:54:14 -0500)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git ipu3
> 
> for you to fetch changes up to 0bf3352560b82c12380823f035f5fb2171683f23:
> 
>   media: intel-ipu3: cio2: mark more PM functions as __maybe_unused (2018-01-09 13:16:07 +0200)
> 
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>       media: intel-ipu3: cio2: mark more PM functions as __maybe_unused
> 
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I got more changes than mentioned above:

git pull logs
Updating e3ee691dbf24..8d677b031a4f
Fast-forward
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Something wrong happened here.

Regards,
Mauro



Cheers,
Mauro
