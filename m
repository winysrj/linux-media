Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:43014 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755877AbdKBLRA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 07:17:00 -0400
Received: by mail-io0-f196.google.com with SMTP id 134so13118194ioo.0
        for <linux-media@vger.kernel.org>; Thu, 02 Nov 2017 04:17:00 -0700 (PDT)
MIME-Version: 1.0
From: Menion <menion@gmail.com>
Date: Thu, 2 Nov 2017 12:16:39 +0100
Message-ID: <CAJVZm6euviGF_HFfTT9-CUR75eGkJMVpDo29ZzOf4yMyVXX40A@mail.gmail.com>
Subject: 32bit userland cannot work with DVB drivers in 64bit kernel, design issue
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all
I am investigating for Armbian, the feasability of running 32bit
userland on single board computers based on arm64 SoC, where only 64
bit kernel is available, for reducing the memory footprint.
I have discovered that there is a flaw in the DVB frontend ioctl (at
least) that prevents to do so.
in frontend.h the biggest problem is:

struct dtv_properties {
__u32 num;
struct dtv_property *props;
};

The master userland-kernel ioctl structure is based on an array set by
pointer, so the 32bit userland will allocate 32bit pointer (and the
resulting structure size) while the 64bit kernel will expect the 64bit
pointers
Also

struct dtv_property {
__u32 cmd;
__u32 reserved[3];
union {
__u32 data;
struct dtv_fe_stats st;
struct {
__u8 data[32];
__u32 len;
__u32 reserved1[3];
void *reserved2;
} buffer;
} u;
int result;
} __attribute__ ((packed));

The void *reserved2 field will also give problem when crossing the
32-64bits boundaries
As today the endire dvb linux infrastructure can only work in 32-32
and 64-64 bit mode
Bye

Antonio
