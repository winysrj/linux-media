Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55265 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab1KNPTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 10:19:45 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAEFJgDN005120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 09:19:44 -0600
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [GIT PULL] davinci vpbe: enable DM365 v4l2 display driver
Date: Mon, 14 Nov 2011 15:19:39 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F75FAD1@DBDE01.ent.ti.com>
References: <1317214968-8679-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1317214968-8679-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
 A gentle reminder for the pull request. These have been acked by Hans.

Cheers,
-Manju

On Wed, Sep 28, 2011 at 18:32:48, Hadli, Manjunath wrote:
> Mauro,
>   Please pull : 
> git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git  for_mauro
> 
> The patchset adds incremental changes necessary to enable dm365
> v4l2 display driver, which includes vpbe display driver changes, osd specific changes and venc changes. The changes are incremental in nature,addind a few HD modes, and taking care of register level changes.
> 
> The patches are tested for both SD and HD modes.
> 
> Manjunath Hadli (3):
>   davinci vpbe: add dm365 VPBE display driver changes
>   davinci vpbe: add dm365 and dm355 specific OSD changes
>   davinci vpbe: add VENC block changes to enable dm365 and dm355
> 
>  drivers/media/video/davinci/vpbe.c      |   48 +++-
>  drivers/media/video/davinci/vpbe_osd.c  |  472 ++++++++++++++++++++++++++++---  drivers/media/video/davinci/vpbe_venc.c |  205 ++++++++++++--
>  include/media/davinci/vpbe.h            |   16 +
>  include/media/davinci/vpbe_venc.h       |    4 +
>  5 files changed, 677 insertions(+), 68 deletions(-)
> 
> 

