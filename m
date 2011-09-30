Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:38687 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1I3VQO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 17:16:14 -0400
Date: Sat, 1 Oct 2011 00:16:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 3.2] S5K6AAFX sensor driver and a videobuf2
 update
Message-ID: <20110930211608.GI6180@valkosipuli.localdomain>
References: <4E85EA07.7060606@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E85EA07.7060606@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Sep 30, 2011 at 06:10:47PM +0200, Sylwester Nawrocki wrote:
> Hi Mauro,
> 
> please pull from
>   git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx
> 
> for S5K6AAFX sensor subdev driver, a videbuf2 enhancement for non-MMU systems
> and minor s5p-mfc amendment changing the firmware name to something more
> generic as the driver supports multiple SoC versions.
> 
> 
> The following changes since commit 446b792c6bd87de4565ba200b75a708b4c575a06:
> 
>   [media] media: DocBook: Fix trivial typo in Sub-device Interface (2011-09-27
> 09:14:58 -0300)
> 
> are available in the git repository at:
>   git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx
> 
> Sachin Kamat (1):
>       MFC: Change MFC firmware binary name
> 
> Scott Jiang (1):
>       vb2: add vb2_get_unmapped_area in vb2 core
> 
> Sylwester Nawrocki (2):
>       v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
>       v4l: Add v4l2 subdev driver for S5K6AAFX sensor

I'd like to ask you what's your intention regarding the preset functionality
in this driver? My understanding it it isn't provided to user space
currently, nor we have such drivers currently (that I know of).

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
