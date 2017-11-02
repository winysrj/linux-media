Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:36842 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932571AbdKBSwj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 14:52:39 -0400
Date: Thu, 2 Nov 2017 18:52:36 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Menion <menion@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: 32bit userland cannot work with DVB drivers in 64bit kernel,
 design issue
Message-ID: <20171102185236.6c0329fd@alans-desktop>
In-Reply-To: <CAJVZm6euviGF_HFfTT9-CUR75eGkJMVpDo29ZzOf4yMyVXX40A@mail.gmail.com>
References: <CAJVZm6euviGF_HFfTT9-CUR75eGkJMVpDo29ZzOf4yMyVXX40A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2 Nov 2017 12:16:39 +0100
Menion <menion@gmail.com> wrote:

> Hi all
> I am investigating for Armbian, the feasability of running 32bit
> userland on single board computers based on arm64 SoC, where only 64
> bit kernel is available, for reducing the memory footprint.
> I have discovered that there is a flaw in the DVB frontend ioctl (at
> least) that prevents to do so.
> in frontend.h the biggest problem is:
> 
> struct dtv_properties {
> __u32 num;
> struct dtv_property *props;
> };
> 
> The master userland-kernel ioctl structure is based on an array set by
> pointer, so the 32bit userland will allocate 32bit pointer (and the
> resulting structure size) while the 64bit kernel will expect the 64bit
> pointers

And in some cases the pointer might end up aligned to the next 64bit
boundary.

> The void *reserved2 field will also give problem when crossing the
> 32-64bits boundaries
> As today the endire dvb linux infrastructure can only work in 32-32
> and 64-64 bit mode

If this isn't handled by the existing media compat_ioctl support then you
can send patches to use compat_ioctl handlers to fix this.

Alan
