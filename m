Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50147 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2JHRg5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 13:36:57 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so221609iea.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 10:36:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349686172.28116.0.camel@avionic-0108.adnet.avionic-design.de>
References: <1349359468-18965-1-git-send-email-julian@jusst.de>
	<CALF0-+U7uPNb058y-FZGt_tvtgh8FMtqf7uRHA5p7h+BCDCXow@mail.gmail.com>
	<1349686172.28116.0.camel@avionic-0108.adnet.avionic-design.de>
Date: Mon, 8 Oct 2012 14:36:56 -0300
Message-ID: <CALF0-+Wj+SoJxz7R5Eejo35-abrGrR855zxqYfA5XGMceou5Eg@mail.gmail.com>
Subject: Re: [PATCH] tm6000: Add parameter to keep urb bufs allocated.
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Julian Scheel <julian@jusst.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 8, 2012 at 5:49 AM, Julian Scheel <julian@jusst.de> wrote:
> Hi Ezequiel,
>
> Am Donnerstag, den 04.10.2012, 14:35 -0300 schrieb Ezequiel Garcia:
>> Nice work! Just one pico-tiny nitpick:
>
> Should I update the patch to reflect this? Or is it ok if the maintainer
> integrated your proposal when comitting it?
>

You can re-send a new patch with this subject:

[PATCH v2] tm6000: Add parameter to keep urb bufs allocated

Like here:
https://lkml.org/lkml/2012/9/23/128

Notice you can place comments (like a patch changelog)
after the:

Signed-off
---

The maintainer will pick the latest version of each patch.

Thanks!
Ezequiel.
