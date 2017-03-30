Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-2.goneo.de ([85.220.129.31]:49423 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932650AbdC3H6Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 03:58:16 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 02/22] docs-rst: convert usb docbooks to ReST
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com>
Date: Thu, 30 Mar 2017 09:48:40 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Alexander Dahl <post@lespocky.de>,
        Jonathan Cameron <jic23@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7D76BCB2-53F5-4BD4-8205-5A4852164C91@darmarit.de>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com> <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am 29.03.2017 um 20:54 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> As we're moving out of DocBook, let's convert the remaining
> USB docbooks to ReST.
> 
> The transformation itself on this patch is a no-brainer
> conversion using pandoc.

right, its a no-brainer ;-) I'am not very happy with this
conversions, some examples see below.

I recommend to use a more elaborate conversion as starting point,
e.g. from my sphkerneldoc project:

* https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/gadget
* https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/writing_musb_glue_layer
* https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/writing_usb_driver

Since these DocBooks hasn't been changed in the last month, the linked reST
should be up to date.

	
> +Kernel Mode Gadget API
> +======================
> +
> +Gadget drivers declare themselves through a *struct
> +usb\_gadget\_driver*, which is responsible for most parts of enumeration
> +for a *struct usb\_gadget*. The response to a set\_configuration usually
> +involves enabling one or more of the *struct usb\_ep* objects exposed by
> +the gadget, and submitting one or more *struct usb\_request* buffers to

quoting of all underlines is not needed.

> +!Iinclude/linux/usb/composite.h !Edrivers/usb/gadget/composite.c
> +Composite Device Functions
> +--------------------------
> +
> +At this writing, a few of the current gadget drivers have been converted
> +to this framework. Near-term plans include converting all of them,
> +except for "gadgetfs".
> +
> +!Edrivers/usb/gadget/function/f\_acm.c
> +!Edrivers/usb/gadget/function/f\_ecm.c
> +!Edrivers/usb/gadget/function/f\_subset.c
> +!Edrivers/usb/gadget/function/f\_obex.c
> +!Edrivers/usb/gadget/function/f\_serial.c
> +Peripheral Controller Drivers
> +=============================

I guess we miss some documentation here.

-- Markus --
