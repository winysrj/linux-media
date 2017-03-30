Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53377 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752931AbdC3IV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 04:21:58 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Alexander Dahl <post@lespocky.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 02/22] docs-rst: convert usb docbooks to ReST
In-Reply-To: <7D76BCB2-53F5-4BD4-8205-5A4852164C91@darmarit.de>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com> <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com> <7D76BCB2-53F5-4BD4-8205-5A4852164C91@darmarit.de>
Date: Thu, 30 Mar 2017 11:21:51 +0300
Message-ID: <87y3vn2mzk.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Mar 2017, Markus Heiser <markus.heiser@darmarit.de> wrote:
> Hi Mauro,
>
> Am 29.03.2017 um 20:54 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>
>> As we're moving out of DocBook, let's convert the remaining
>> USB docbooks to ReST.
>> 
>> The transformation itself on this patch is a no-brainer
>> conversion using pandoc.
>
> right, its a no-brainer ;-) I'am not very happy with this
> conversions, some examples see below.
>
> I recommend to use a more elaborate conversion as starting point,
> e.g. from my sphkerneldoc project:
>
> * https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/gadget
> * https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/writing_musb_glue_layer
> * https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/writing_usb_driver
>
> Since these DocBooks hasn't been changed in the last month, the linked reST
> should be up to date.

Markus, I know you've done a lot of work on your conversions, and you
like to advocate them, but AFAICT you have never posted the conversions
as patches to the list. Your project isn't a clone of the kernel
tree. It's a pile of .rst files that nobody knows how to produce from
current upstream DocBook .tmpl files. I'm sorry, but this just doesn't
work that way.

At this point I'd just go with what Mauro has. It's here now, as
patches. We've seen from the GPU documentation that polishing the
one-time initial conversion is, after a point, wasted effort. Having the
documentation in rst attracts more attention and contributions, and any
remaining issues will get ironed out in rst.

This is also one reason I'm in favor of just bulk converting the rest of
the .tmpl files using Documentation/sphinx/tmplcvt, get rid of DocBook
and be done with it, and have the crowds focus on rst.


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
