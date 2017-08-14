Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:33987 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdHNWz5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 18:55:57 -0400
Received: by mail-ua0-f180.google.com with SMTP id q25so42210988uah.1
        for <linux-media@vger.kernel.org>; Mon, 14 Aug 2017 15:55:56 -0700 (PDT)
MIME-Version: 1.0
From: "Werner, Zachary" <werner@teralogics.com>
Date: Mon, 14 Aug 2017 18:55:55 -0400
Message-ID: <CAHJmb1fQhLC-A6Uo91G7eVH1S+8qtwYjSN_3P=tuft1+kpveDA@mail.gmail.com>
Subject: Unknown symbol errors with latest RH7 kernel using meda_build
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm new to mailing lists, so I'm sorry if this message is poorly formatted.

I have been compiling v4l on RH7 using very minor changes (made it
into an rpm, have to remove 'v3.16_wait_on_bit.patch' from the
backports) for a while now. I had been using an older set of firmware
and git hash from the media_build repo for several kernels, but the
latest kernel release had an issue loading the modules. The latest
kernel release, 3.10.0-693.el7.x86_64, builds with a few warnings
(below), but still builds successfully. After installing the new
kernel, updated rpm, and rebooting, I get the following in dmesg:

videobuf2_v4l2: Unknown symbol vb2_buffer_in_use (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_queue_init (err 0)
videobuf2_v4l2: Unknown symbol vb2_verify_memory_type (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_reqbufs (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_expbuf (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_create_bufs (err 0)
videobuf2_v4l2: disagrees about version of symbol vb2_write
videobuf2_v4l2: Unknown symbol vb2_write (err -22)
videobuf2_v4l2: Unknown symbol vb2_core_queue_release (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_prepare_buf (err 0)
videobuf2_v4l2: disagrees about version of symbol vb2_read
videobuf2_v4l2: Unknown symbol vb2_read (err -22)
videobuf2_v4l2: Unknown symbol vb2_core_poll (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_streamon (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_querybuf (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_qbuf (err 0)
videobuf2_v4l2: disagrees about version of symbol vb2_mmap
videobuf2_v4l2: Unknown symbol vb2_mmap (err -22)
videobuf2_v4l2: Unknown symbol vb2_core_dqbuf (err 0)
videobuf2_v4l2: Unknown symbol vb2_core_streamoff (err 0)

Since the videobuf2-core module loaded, I'm not sure why the symbols
are missing. If I compile and install using the latest git versions
using the rpm and locally on the box (using './build' and 'make
install'), I get the same results. I've tried looking into issues with
the symbols not being exported, but the code seems to have them there,
and considering this used to work, I'm a at a loss.

Some of the warnings on build include various files that report:

WARNING: /root/rpmbuild/BUILD/v4l/media_build/v4l/dvb-core.o
(.discard.unreachable): unexpected non-allocatable section.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

After which this block comes up:

WARNING: "frame_vector_to_pages"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-vmalloc.ko]
undefined!
WARNING: "frame_vector_to_pfns"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-vmalloc.ko]
undefined!
WARNING: "dma_buf_export_named"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-vmalloc.ko]
undefined!
WARNING: "frame_vector_create"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-memops.ko]
undefined!
WARNING: "frame_vector_destroy"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-memops.ko]
undefined!
WARNING: "get_vaddr_frames"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-memops.ko]
undefined!
WARNING: "put_vaddr_frames"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-memops.ko]
undefined!
WARNING: "frame_vector_to_pages"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-dma-sg.ko]
undefined!
WARNING: "dma_buf_export_named"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-dma-sg.ko]
undefined!
WARNING: "frame_vector_to_pages"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-dma-contig.ko]
undefined!
WARNING: "frame_vector_to_pfns"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-dma-contig.ko]
undefined!
WARNING: "dma_buf_export_named"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-dma-contig.ko]
undefined!
WARNING: "v4l_vb2q_enable_media_source"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/videobuf2-core.ko]
undefined!
WARNING: "v4l2_mc_create_media_graph"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/saa7134.ko] undefined!
WARNING: "syscon_regmap_lookup_by_phandle"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/ir-hix5hd2.ko] undefined!
WARNING: "v4l2_mc_create_media_graph"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/em28xx-v4l.ko] undefined!
WARNING: "__v4l2_ctrl_s_ctrl"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/cx8800.ko] undefined!
WARNING: "__v4l2_ctrl_s_ctrl"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/cx88-alsa.ko] undefined!
WARNING: "__v4l2_ctrl_s_ctrl"
[/root/rpmbuild/BUILD/v4l/media_build/v4l/cx23885.ko] undefined!

I don't recall these errors in earlier builds, and I'm not sure if
they are perhaps related to the issues I'm getting on module load.

Any help is appreciated.

Zach
