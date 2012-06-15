Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1190 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2FOHjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 03:39:40 -0400
Message-ID: <4FDAE6B0.5020301@xs4all.nl>
Date: Fri, 15 Jun 2012 09:39:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 00/10] media file tree reorg - part 1
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/06/12 22:35, Mauro Carvalho Chehab wrote:
> As discussed a while ago, breaking media drivers by V4L or DVB
> is confusing, as:
> 	- hybrid devices are at V4L drivers;
> 	- DVB-only devices for chips that support analog are at
> 	  V4L drivers;
> 	- Analog support addition on a DVB driver would require it
> 	  to move to V4L drivers.
>
> Instead, move all drivers into a per-bus directory, and common drivers
> used by more than one driver into /common.
>
> This is the part 1 of this idea: it moves the core drivers to
> /drivers/media/foo-core, and re-arranges the DVB files.
>
> After this patch series, the directory structure will be:
>
> drivers/media/
> |-- common
> |   `--<common drivers>
> |-- dvb-core
> |-- dvb-frontends
> |-- firewire
> |-- mmc
> |   `--<mmc/sdio drivers>
> |-- pci
> |   `--<pci/pcie drivers>
> |-- radio
> |   `--<radio drivers>
> |-- rc
> |   `-- keymaps
> |-- tuners
> |-- usb
> |   `--<usb drivers>
> |-- v4l2-core
> `-- video
>
> PS.: The "video" directory is currently unchanged. It currently
>       contains subdevs, common V4L drivers, and V4L bridges.
>
> On this series, I avoided mixing the file tree reorganization with
> menu improvements. Those will happen together with the second part,
> when the devices under video will be moved to /common, /usb, /pci...
> dirs.

Looks good to me. I like that saa7146 gets its own directory :-)

One request: before you commit this, can you go through the pending 
patches for 3.6 and apply all the non-controversial ones? Otherwise 
everyone will have to rebase their work.

Regards,

	Hans
