Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:43523 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754520AbdKCJ3x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 05:29:53 -0400
Received: by mail-io0-f196.google.com with SMTP id 134so4956768ioo.0
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 02:29:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171102185236.6c0329fd@alans-desktop>
References: <CAJVZm6euviGF_HFfTT9-CUR75eGkJMVpDo29ZzOf4yMyVXX40A@mail.gmail.com>
 <20171102185236.6c0329fd@alans-desktop>
From: Menion <menion@gmail.com>
Date: Fri, 3 Nov 2017 10:29:31 +0100
Message-ID: <CAJVZm6d7yXXGDhkVNdCwit1MOwj2nnWYj8vnaD01-hYz8ptWDA@mail.gmail.com>
Subject: Re: 32bit userland cannot work with DVB drivers in 64bit kernel,
 design issue
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the moment, I am focusing on the frontend ioctl problem
According to the fops:

static const struct file_operations dvb_frontend_fops = {
.owner = THIS_MODULE,
.unlocked_ioctl = dvb_generic_ioctl,
.poll = dvb_frontend_poll,
.open = dvb_frontend_open,
.release = dvb_frontend_release,
.llseek = noop_llseek,
};

There is no support for compact_ioctl, so it must be added

2017-11-02 19:52 GMT+01:00 Alan Cox <gnomes@lxorguk.ukuu.org.uk>:
> On Thu, 2 Nov 2017 12:16:39 +0100
> Menion <menion@gmail.com> wrote:
>
>> Hi all
>> I am investigating for Armbian, the feasability of running 32bit
>> userland on single board computers based on arm64 SoC, where only 64
>> bit kernel is available, for reducing the memory footprint.
>> I have discovered that there is a flaw in the DVB frontend ioctl (at
>> least) that prevents to do so.
>> in frontend.h the biggest problem is:
>>
>> struct dtv_properties {
>> __u32 num;
>> struct dtv_property *props;
>> };
>>
>> The master userland-kernel ioctl structure is based on an array set by
>> pointer, so the 32bit userland will allocate 32bit pointer (and the
>> resulting structure size) while the 64bit kernel will expect the 64bit
>> pointers
>
> And in some cases the pointer might end up aligned to the next 64bit
> boundary.
>
>> The void *reserved2 field will also give problem when crossing the
>> 32-64bits boundaries
>> As today the endire dvb linux infrastructure can only work in 32-32
>> and 64-64 bit mode
>
> If this isn't handled by the existing media compat_ioctl support then you
> can send patches to use compat_ioctl handlers to fix this.
>
> Alan
