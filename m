Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40585 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1DCPnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 11:43:53 -0400
Received: by vxi39 with SMTP id 39so3655641vxi.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 08:43:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110403001856.GC3062@gallifrey>
References: <20110403001856.GC3062@gallifrey>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 3 Apr 2011 08:42:12 -0700
Message-ID: <BANLkTimAwV5iJppn_XoSyH5SYPjpNeZqWw@mail.gmail.com>
Subject: Re: vb2_plane 'mapped' signed bit field
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Apr 2, 2011 at 17:18, Dr. David Alan Gilbert <linux@treblig.org> wrote:
> Hi Pawel,
>  'sparse' spotted that vb2_plane's mapped field is a signed
> bitfield:
>
> include/media/videobuf2-core.h:78:41 1 bit signed int
>
> struct vb2_plane {
>       void                    *mem_priv;
>       int                     mapped:1;
> };
>
> that probably should be an unsigned int (I can see code that assigns
> 1 to it that just won't fit).

Hi David,
Thanks for the report, will fix soon.

-- 
Best regards,
Pawel Osciak
