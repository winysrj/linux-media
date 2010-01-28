Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58273 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab0A1JTF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 04:19:05 -0500
MIME-Version: 1.0
In-Reply-To: <4B60CB5A.7000109@epfl.ch>
References: <4B60CB5A.7000109@epfl.ch>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 28 Jan 2010 10:18:46 +0100
Message-ID: <ac3eb2511001280118s4e00dca3l905a8ed7d532bde2@mail.gmail.com>
Subject: Re: [Q] udev and soc-camera
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: linux-media@vger.kernel.org, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 28, 2010 at 00:25, Valentin Longchamp
<valentin.longchamp@epfl.ch> wrote:
> I have a system that is built with OpenEmbedded where I use a mt9t031 camera
> with the soc-camera framework. The mt9t031 works ok with the current kernel
> and system.
>
> However, udev does not create the /dev/video0 device node. I have to create
> it manually with mknod and then it works well. If I unbind the device on the
> soc-camera bus (and then eventually rebind it), udev then creates the node
> correctly. This looks like a "timing" issue at "coldstart".
>
> OpenEmbedded currently builds udev 141 and I am using kernel 2.6.33-rc5 (but
> this was already like that with earlier kernels).
>
> Is this problem something known or has at least someone already experienced
> that problem ?

You need to run "udevadm trigger" as the bootstrap/coldplug step,
after you stared udev. All the devices which are already there at that
time, will not get created by udev, only new ones which udev will see
events for. The trigger will tell the kernel to send all events again.

Or just use the kernel's devtmpfs, and all this should work, even
without udev, if you do not have any other needs than plain device
nodes.

Kay
