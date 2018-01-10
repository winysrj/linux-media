Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:39085 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752678AbeAJRc5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 12:32:57 -0500
Received: by mail-vk0-f65.google.com with SMTP id n4so1766835vkd.6
        for <linux-media@vger.kernel.org>; Wed, 10 Jan 2018 09:32:56 -0800 (PST)
MIME-Version: 1.0
From: "Werner, Zachary" <werner@teralogics.com>
Date: Wed, 10 Jan 2018 12:32:55 -0500
Message-ID: <CAHJmb1dut9vKuOd9C_6NOsp2g85JNRmc35ZfjOFyPdUkod2UMA@mail.gmail.com>
Subject: media_build modprobe issues with latest Centos7
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to build using the latest media_build and media_tree
branches, but I'm getting an issue when running `modprobe -a cx23885`
(from dmesg):

[ 5373.246321] Linux video capture interface: v2.00
[ 5373.257419] rc_core: loading out-of-tree module taints kernel.
[ 5373.257452] rc_core: module verification failed: signature and/or
required key missing - tainting kernel
[ 5373.257939] rc_core: IR Remote Control driver registered, major 246
[ 5373.257945] WARNING: You are using an experimental version of the
media stack.
        As the driver is backported to an older kernel, it doesn't offer
        enough quality for its usage in production.
        Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
        e3ee691dbf24096ea51b3200946b11d68ce75361 media: ov5640: add
support of RGB565 and YUYV formats
        f22996db44e2db73b333de25a8939fef2bab9620 media: ov5640: add
support of DVP parallel interface
        495f014d313df677015ceedf6cec5feba1ac6570 media: dt-bindings:
ov5640: refine CSI-2 and add parallel interface
[ 5373.432275] videobuf2_v4l2: Unknown symbol vb2_buffer_in_use (err 0)
[ 5373.432283] videobuf2_v4l2: Unknown symbol vb2_core_queue_init (err 0)
[ 5373.432290] videobuf2_v4l2: Unknown symbol vb2_verify_memory_type (err 0)
[ 5373.432297] videobuf2_v4l2: Unknown symbol vb2_core_reqbufs (err 0)
[ 5373.432303] videobuf2_v4l2: Unknown symbol vb2_core_expbuf (err 0)
[ 5373.432310] videobuf2_v4l2: Unknown symbol vb2_core_create_bufs (err 0)
[ 5373.432321] videobuf2_v4l2: disagrees about version of symbol vb2_write
[ 5373.432323] videobuf2_v4l2: Unknown symbol vb2_write (err -22)
[ 5373.432330] videobuf2_v4l2: Unknown symbol vb2_core_queue_release (err 0)
[ 5373.432343] videobuf2_v4l2: Unknown symbol vb2_core_prepare_buf (err 0)
[ 5373.432344] videobuf2_v4l2: disagrees about version of symbol vb2_read
[ 5373.432345] videobuf2_v4l2: Unknown symbol vb2_read (err -22)
[ 5373.432351] videobuf2_v4l2: Unknown symbol vb2_core_poll (err 0)
[ 5373.432357] videobuf2_v4l2: Unknown symbol vb2_core_streamon (err 0)
[ 5373.432364] videobuf2_v4l2: Unknown symbol vb2_core_querybuf (err 0)
[ 5373.432371] videobuf2_v4l2: Unknown symbol vb2_core_qbuf (err 0)
[ 5373.432372] videobuf2_v4l2: disagrees about version of symbol vb2_mmap
[ 5373.432373] videobuf2_v4l2: Unknown symbol vb2_mmap (err -22)
[ 5373.432379] videobuf2_v4l2: Unknown symbol vb2_core_dqbuf (err 0)
[ 5373.432386] videobuf2_v4l2: Unknown symbol vb2_core_streamoff (err 0)

`lsmod | grep v4l`:

v4l2_common            21263  1 cx2341x
videodev              126499  3 cx2341x,v4l2_common,videobuf2_core
i2c_core               40756  6
drm,i2c_piix4,drm_kms_helper,v4l2_common,tveeprom,videodev

I have verified that there are no other videobuf or v4l modules
installed in the kernel modules directory, and reloading the modules
and rebooting does not solve the issue.

This was not an issue for kernel version `3.10.0-693`, but others
since then have been building but not loading properly with similar
issues. I'm currently using `3.10.0-693.11.6`.

I have had to make a couple small patches to make the media_build work
with Centos7. I have patched out from `backports.txt` the
`v4.14_compiler_h.patch` and `add v3.16_wait_on_bit.patch` lines as
the kernel appears to have fixed these issues. I have also removed the
`__LINUX_COMPILER_TYPES_H` from `compiler-gcc.h` as it was causing an
issue as well.

Any ideas on how to solve this or any troubleshooting tips?

Zach Werner (wernerz)
