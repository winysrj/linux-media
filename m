Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52511 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbcBHKtk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 05:49:40 -0500
Subject: Re: [PATCH 0/12] TW686x driver
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <m337tif6om.fsf@t19.piap.pl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56B872C0.1050200@xs4all.nl>
Date: Mon, 8 Feb 2016 11:49:36 +0100
MIME-Version: 1.0
In-Reply-To: <m337tif6om.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/2016 09:29 AM, Krzysztof Hałasa wrote:
> Hi,
> 
> I'm posting a driver for TW686[4589]-based PCIe cards. The first patch
> has been posted and reviewed by Ezequiel back in July 2015, the
> subsequent patches are changes made in response to the review and/or are
> required by the more recent kernel versions.
> 
> This driver lacks CMA-based frame mode DMA operation, I'll add it a bit
> later. Also:
> - I haven't converted the kthread to a workqueue - the driver is
>   modeled after other code and it can be done later, if needed
> - I have skipped suggested PCI ID changes and the 704 vs 720 pixels/line
>   question - this may need further consideration.
> 
> Please merge.

Please repost as a single patch. Also make sure it is based on the latest
media_tree master branch.

Your current patch series breaks bisectability (basically, after patch 1 it
won't compile since it's not using vb2_v4l2_buffer yet).

Also, for new drivers we generally don't care about the history, we prefer a
single patch. That makes it easier to review as well.

I'll take a good look at the code once I have a v2.

Now, I am not planning to merge that, but I will compare it to what Ezequiel has
and use that comparison as a starting point for further discussions.

As I mentioned before, my preference is to merge a driver that supports both
frame and field modes (or whatever they are called).

Regards,

	Hans

> 
> The following changes since Linux 4.4 are available in the git
> repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux.git techwell-4.4
> 
> for you to fetch changes up to 8e495778acd4602c472cefa460a1afb41c4b8f25:
> 
>   [MEDIA] TW686x: return VB2_BUF_STATE_ERROR frames on timeout/errors (2016-01-27 14:47:41 +0100)
> 
> ----------------------------------------------------------------
> Krzysztof Hałasa (12):
>       [MEDIA] Add support for TW686[4589]-based frame grabbers
>       [MEDIA] TW686x: Trivial changes suggested by Ezequiel Garcia
>       [MEDIA] TW686x: Switch to devm_*()
>       [MEDIA] TW686x: Fix s_std() / g_std() / g_parm() pointer to self
>       [MEDIA] TW686x: Fix handling of TV standard values
>       [MEDIA] TW686x: Fix try_fmt() color space
>       [MEDIA] TW686x: Add enum_input() / g_input() / s_input()
>       [MEDIA] TW686x: do not use pci_dma_supported()
>       [MEDIA] TW686x: switch to vb2_v4l2_buffer
>       [MEDIA] TW686x: handle non-NULL format in queue_setup()
>       [MEDIA] TW686x: Track frame sequence numbers
>       [MEDIA] TW686x: return VB2_BUF_STATE_ERROR frames on timeout/errors
> 
>  drivers/media/pci/Kconfig               |   1 +
>  drivers/media/pci/Makefile              |   1 +
>  drivers/media/pci/tw686x/Kconfig        |  16 ++
>  drivers/media/pci/tw686x/Makefile       |   3 +
>  drivers/media/pci/tw686x/tw686x-core.c  | 140 +++++++++++++
>  drivers/media/pci/tw686x/tw686x-regs.h  | 103 +++++++++
>  drivers/media/pci/tw686x/tw686x-video.c | 815 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/pci/tw686x/tw686x.h       | 118 +++++++++++
>  8 files changed, 1197 insertions(+)
>  create mode 100644 drivers/media/pci/tw686x/Kconfig
>  create mode 100644 drivers/media/pci/tw686x/Makefile
>  create mode 100644 drivers/media/pci/tw686x/tw686x-core.c
>  create mode 100644 drivers/media/pci/tw686x/tw686x-regs.h
>  create mode 100644 drivers/media/pci/tw686x/tw686x-video.c
>  create mode 100644 drivers/media/pci/tw686x/tw686x.h
> 
> Thanks.
> 

