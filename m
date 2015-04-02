Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33591 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbbDBQ4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2015 12:56:46 -0400
Date: Thu, 2 Apr 2015 13:56:37 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, sean@mess.org
Subject: Re: [PATCH 0/2] NEC scancodes and protocols in keymaps
Message-ID: <20150402135637.28ec4dbf@recife.lan>
In-Reply-To: <20150402120047.20068.31662.stgit@zeus.muc.hardeman.nu>
References: <20150402120047.20068.31662.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 02 Apr 2015 14:02:57 +0200
David Härdeman <david@hardeman.nu> escreveu:

> The following two patches should show more clearly what I mean by
> adding protocols to the keytables (and letting userspace add
> keytable entries with explicit protocol information). Consider
> it a basis for discussion.
> 
> Each patch has a separate description, please refer to those for
> more information.

Interesting approach. It would be good to also have a patch for
v4l-utils rc-keycode userspace, for it to use the new way when
available. An option to fallback to the old way would also be
useful, in order to allow testing the backward compatibility.

> 
> ---
> 
> David Härdeman (2):
>       rc-core: use the full 32 bits for NEC scancodes
>       rc-core: don't throw away protocol information
> 
> 
>  drivers/media/rc/ati_remote.c            |    1 
>  drivers/media/rc/imon.c                  |    7 +
>  drivers/media/rc/ir-nec-decoder.c        |   26 ---
>  drivers/media/rc/rc-main.c               |  233 ++++++++++++++++++++++++------
>  drivers/media/usb/dvb-usb-v2/af9015.c    |   22 +--
>  drivers/media/usb/dvb-usb-v2/af9035.c    |   23 +--
>  drivers/media/usb/dvb-usb-v2/az6007.c    |   16 +-
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c  |   20 +--
>  drivers/media/usb/dvb-usb/dib0700_core.c |   24 +--
>  drivers/media/usb/em28xx/em28xx-input.c  |   37 +----
>  include/media/rc-core.h                  |   26 +++
>  include/media/rc-map.h                   |   23 ++-
>  12 files changed, 264 insertions(+), 194 deletions(-)
> 
> --
> David Härdeman
