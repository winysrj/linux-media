Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36031 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdENMyP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 May 2017 08:54:15 -0400
Received: by mail-oi0-f67.google.com with SMTP id w138so15219131oiw.3
        for <linux-media@vger.kernel.org>; Sun, 14 May 2017 05:54:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL8zT=jwVquxzvnieVA2njSTdL98mOt+n=oy=Nb8ptXdBbJ-1w@mail.gmail.com>
References: <CAF_dkJB=2PNbD79msw=G47U-6QkajDOWwLJbr3pCaTQeqn=fXA@mail.gmail.com>
 <CAL8zT=jwVquxzvnieVA2njSTdL98mOt+n=oy=Nb8ptXdBbJ-1w@mail.gmail.com>
From: Patrick Doyle <wpdster@gmail.com>
Date: Sun, 14 May 2017 08:53:44 -0400
Message-ID: <CAF_dkJCmY-n_0MdceZGXRA5fuPuMCg395Ct8x8WGRF+QCAp1eg@mail.gmail.com>
Subject: Re: Is it possible to have a binary blob custom control?
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 14, 2017 at 3:27 AM, Jean-Michel Hautbois
<jhautbois@gmail.com> wrote:
> Maybe a debugfs would be easier than an ioctl? Do you have a good reason to
> use the control framework for that matter?

I implemented this once before, using a custom ioctl, which meant that
I had to maintain a custom kernel header file.  I am looking for a
better way to do this.  I wondered if I could do this through the V4L2
framework, but perhaps, as you suggest, the debugfs would be better.

The underlying issue I am trying to address is this:  I have an
application that used the ov7740 imager from Omnivision.  I have
custom register settings that were provided to me under NDA.  I have
asked Omnivision if I can publish those register settings in GPL'd
source code, but have received no response.  So, my alternative
approach was to modify the GPL driver to accept custom register
settings (through a new IOCTL).  That way I can bake the register
settings in my custom application and still use the GPL'd driver.

But that meant that I had to define a header file that gets included
in the kernel, and I need some way to build my application with a
reference to that header file.  This is error prone.

I like your suggestion of a debugfs API.  That way I could open
/proc/sys/debug/ov7740/custom_vga_settings and write my register
settings there.  The name is the documentation.  The format is in the
README.

Are there other ways I could do this?  Certainly?  Are there better
ways I could do this?  I'm open to opinions.

Thanks again.

--wpd
