Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44339 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbeJFQ5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 Oct 2018 12:57:21 -0400
Subject: Re: [PATCH v2 0/2] Add SECO Boards CEC device driver
To: ektor5 <ek5.chimenti@gmail.com>
Cc: luca.pisani@udoo.org, sean@mess.org, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org
References: <cover.1538474121.git.ek5.chimenti@gmail.com>
 <cover.1538760098.git.ek5.chimenti@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bdec2327-8c19-8ffb-9862-6df2e6e697c7@xs4all.nl>
Date: Sat, 6 Oct 2018 11:54:38 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1538760098.git.ek5.chimenti@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ettore,

On 10/05/2018 07:33 PM, ektor5 wrote:
> This series of patches aims to add CEC functionalities to SECO
> devices, in particular UDOO X86.
> 
> The communication is achieved via Braswell SMBus (i2c-i801) to the
> onboard STM32 microcontroller that handles the CEC signals. The driver
> use direct access to the PCI addresses, due to the limitations of the
> specific driver in presence of ACPI calls.
> 
> The basic functionalities are tested with success with cec-ctl and
> cec-compliance.

This series looks good to me. But can you do one more test:

Update your kernel to the latest media_tree master and also update your
v4l-utils repo to the latest master code.

With all that in place please run:

cec-compliance -A

(have the HDMI output connected to a CEC-capable TV when running this test).

Please report back the output of cec-compliance.

A bunch of CEC bug fixes and improvements were merged yesterday, and the
cec-compliance adapter test is improved to check for issues that were hard
to find in the past.

So it will be good to have a final check of this driver.

Regards,

	Hans

> 
> v2:
>  - Removed useless debug prints
>  - Added DMI && PCI to dependences
>  - Removed useless ifdefs
>  - Renamed all irda references to ir
>  - Fixed SPDX clause
>  - Several style fixes
> 
> Ettore Chimenti (2):
>   media: add SECO cec driver
>   seco-cec: add Consumer-IR support
> 
>  MAINTAINERS                                |   6 +
>  drivers/media/platform/Kconfig             |  22 +
>  drivers/media/platform/Makefile            |   2 +
>  drivers/media/platform/seco-cec/Makefile   |   1 +
>  drivers/media/platform/seco-cec/seco-cec.c | 829 +++++++++++++++++++++
>  drivers/media/platform/seco-cec/seco-cec.h | 141 ++++
>  6 files changed, 1001 insertions(+)
>  create mode 100644 drivers/media/platform/seco-cec/Makefile
>  create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
>  create mode 100644 drivers/media/platform/seco-cec/seco-cec.h
> 
