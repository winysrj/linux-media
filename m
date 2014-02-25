Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:51830 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaBYGAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 01:00:18 -0500
Received: by mail-ve0-f169.google.com with SMTP id c14so3452297vea.14
        for <linux-media@vger.kernel.org>; Mon, 24 Feb 2014 22:00:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8tq8AV+8dr07gE2nXywRnk1EY0VLxQ1ONZdv4hx6gEscQ@mail.gmail.com>
References: <CA+V-a8tq8AV+8dr07gE2nXywRnk1EY0VLxQ1ONZdv4hx6gEscQ@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 25 Feb 2014 11:29:57 +0530
Message-ID: <CA+V-a8uH4A5vHs7ggaYtqMX+E3QJztWRgHGBtLP=27cEXAkRFg@mail.gmail.com>
Subject: Re: [GIT PULL FOR v3.15] Davinci VPFE Patches
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Thu, Feb 20, 2014 at 12:21 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Mauro,
>
> Please pull the following patch for davinci vpfe driver.
>
I have included one more patch from Michael, with a fresh pull request.

Thanks,
--Prabhakar Lad

The following changes since commit efab6b6a6ea9364ececb955f69a9d3ffc6b782a1:

  [media] vivi: queue_setup improvements (2014-02-24 10:59:15 -0300)

are available in the git repository at:

  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_mauro

for you to fetch changes up to b744c55dd23bf61072ae7743e656d515c645f9ff:

  davinci: vpfe: remove deprecated IRQF_DISABLED (2014-02-25 11:11:14 +0530)

----------------------------------------------------------------
Levente Kurusa (1):
      staging: davinci_vpfe: fix error check

Michael Opdenacker (1):
      davinci: vpfe: remove deprecated IRQF_DISABLED

 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |    2 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)
