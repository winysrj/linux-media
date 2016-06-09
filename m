Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51184 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751248AbcFIWcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 18:32:13 -0400
Date: Fri, 10 Jun 2016 01:32:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Augusto Mecking Caringi <augustocaringi@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Kernel 4.7.0-rc2 warnings with Facetime HD camera on Macbook Pro
 8,1
Message-ID: <20160609223209.GY26360@valkosipuli.retiisi.org.uk>
References: <CADFy_4F026LoaGU5JnY7dn+UXzgvYpr4DYj2UZKOw6VLULj3jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADFy_4F026LoaGU5JnY7dn+UXzgvYpr4DYj2UZKOw6VLULj3jg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Augusto,

On Wed, Jun 08, 2016 at 02:00:46AM -0300, Augusto Mecking Caringi wrote:
> Hi,
> 
>     I have a Macbook Pro 8,1 running Linux (Fedora) and until now I
> was running the kernel provided by the distro. Today I decided to
> compile a new kernel from Linus HEAD
> (3613a6245b9fb5091724961e502fd1228de40f32) with the attached .config.
> 
>     During boot I see the following lines:
> 
> [   21.203874] media: Linux media interface: v0.10
> [   21.203888] usbcore: registered new interface driver bcm5974
> [   21.885849] Linux video capture interface: v2.00
> [   22.877744] uvcvideo: Found UVC 1.00 device FaceTime HD Camera
> (Built-in) (05ac:8509)
> [   22.884626] uvcvideo 1-2:1.0: Entity type for entity Processing 3
> was not initialized!
> [   22.887411] uvcvideo 1-2:1.0: Entity type for entity Camera 1 was
> not initialized!
> [   22.889287] input: FaceTime HD Camera (Built-in) as
> /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input18
> [   22.891190] usbcore: registered new interface driver uvcvideo
> [   22.893180] USB Video Class driver (1.1.1)
> 
>      When I open cheese the camera works without problems, but a lot
> of messages like that appear in the kernel ring buffer:
> 
> [  414.181611] ------------[ cut here ]------------
> [  414.181636] WARNING: CPU: 1 PID: 5763 at
> drivers/media/v4l2-core/v4l2-ioctl.c:2174 v4l_cropcap+0x13c/0x160
> [videodev]
> [  414.181641] Modules linked in: iptable_nat nf_nat_ipv4 nf_nat
> uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2
> videobuf2_core videodev media bcm5974 x86_pkg_temp_thermal coretemp
> snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic
> snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core
> [  414.181682] CPU: 1 PID: 5763 Comm: cheese Not tainted
> 4.7.0-rc2-00004-g3613a62 #61
> [  414.181686] Hardware name: Apple Inc.
> MacBookPro8,1/Mac-94245B3640C91C81, BIOS
> MBP81.88Z.0047.B27.1201241646 01/24/12
> [  414.181690]  0000000000000000 ffff88008a907c18 ffffffff8155791d
> 0000000000000000
> [  414.181698]  0000000000000000 ffff88008a907c58 ffffffff810ace66
> 0000087ea01045b2
> [  414.181706]  00000000c02c563a ffff88003fef7018 ffffffffa00cc8c0
> ffff88008a907da8
> [  414.181714] Call Trace:
> [  414.181724]  [<ffffffff8155791d>] dump_stack+0x4f/0x72
> [  414.181732]  [<ffffffff810ace66>] __warn+0xc6/0xe0
> [  414.181739]  [<ffffffff810acf38>] warn_slowpath_null+0x18/0x20
> [  414.181748]  [<ffffffffa00b578c>] v4l_cropcap+0x13c/0x160 [videodev]
> [  414.181758]  [<ffffffffa00b721a>] __video_do_ioctl+0x26a/0x2e0 [videodev]
> [  414.181766]  [<ffffffff81189b49>] ? page_cache_async_readahead+0x89/0xc0
> [  414.181774]  [<ffffffff81573a63>] ? __this_cpu_preempt_check+0x13/0x20
> [  414.181781]  [<ffffffff8119a652>] ? __inc_zone_state+0x42/0xa0
> [  414.181791]  [<ffffffffa00b6cfb>] video_usercopy+0x30b/0x5a0 [videodev]
> [  414.181799]  [<ffffffffa00b6fb0>] ? video_ioctl2+0x20/0x20 [videodev]
> [  414.181807]  [<ffffffff81b78a31>] ? _raw_write_unlock+0x11/0x30
> [  414.181812]  [<ffffffff81b78a59>] ? _raw_spin_unlock+0x9/0x10
> [  414.181818]  [<ffffffff811a9810>] ? handle_mm_fault+0x500/0x1400
> [  414.181827]  [<ffffffffa00b6fa0>] video_ioctl2+0x10/0x20 [videodev]
> [  414.181836]  [<ffffffffa00b2657>] v4l2_ioctl+0xd7/0xe0 [videodev]
> [  414.181842]  [<ffffffff811ea62d>] do_vfs_ioctl+0x8d/0x580
> [  414.181850]  [<ffffffff811f4ca2>] ? __fget+0x72/0xa0
> [  414.181855]  [<ffffffff811eab94>] SyS_ioctl+0x74/0x80
> [  414.181861]  [<ffffffff81b78edb>] entry_SYSCALL_64_fastpath+0x13/0x8f
> [  414.181866] ---[ end trace fc095e890e0ec9cf ]---
> 
>      This warning was introduced in commit "[media] v4l2-ioctl.c:
> improve cropcap compatibility code"
> (95dd7b7e30f385c1c2d5e41457c082c5f6c535b3) from 15/Apr/2016, file
> drivers/media/v4l2-core/v4l2-ioctl.c:2170:
> 
> /*
>  * The determine_valid_ioctls() call already should ensure
>  * that this can never happen, but just in case...
>  */
>  if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_cropcap))
>      return -ENOTTY;
> 
>     Just to emphasize: Despite the warnings, the camera is working ok.

It's a bug, which I believe is fixed by this patch:

<URL:http://www.spinics.net/lists/linux-media/msg100627.html>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
