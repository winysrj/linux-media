Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:33771 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdKQLy5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 06:54:57 -0500
Received: by mail-wr0-f181.google.com with SMTP id 4so1904765wrt.0
        for <linux-media@vger.kernel.org>; Fri, 17 Nov 2017 03:54:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fd92263a2c04a10d58ce465058391e6e8703dc90.1510913595.git.mchehab@s-opensource.com>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
 <fd92263a2c04a10d58ce465058391e6e8703dc90.1510913595.git.mchehab@s-opensource.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 17 Nov 2017 12:54:15 +0100
Message-ID: <CAOFm3uFQGftabX93YEiLfpAoR+7kEvwuLudH+A7Bo4zKa60TOQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] media: usb: add SPDX identifiers to some code I wrote
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 11:21 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> As we're now using SPDX identifiers, on several
> media drivers I wrote, add the proper SPDX, identifying
> the license I meant.
>
> As we're now using the short license, it doesn't make sense to
> keep the original license text.
>
> Also, fix MODULE_LICENSE to properly identify GPL v2.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Mauro,
Thanks ++ .... I can now get rid of a special license detection rule I
had added for the specific language of your notices in the
scancode-toolkit!

FWIW for this 6 patch series:

Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-- 
Cordially
Philippe Ombredanne
