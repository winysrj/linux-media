Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35113 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753883AbeDATpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2018 15:45:19 -0400
Received: by mail-qt0-f173.google.com with SMTP id s2so13818219qti.2
        for <linux-media@vger.kernel.org>; Sun, 01 Apr 2018 12:45:19 -0700 (PDT)
Message-ID: <1522611916.3097.8.camel@ndufresne.ca>
Subject: Re: Webcams not recognized on a Dell Latitude 5285 laptop
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Parrenin
        <frederic.parrenin@univ-grenoble-alpes.fr>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Sun, 01 Apr 2018 15:45:16 -0400
In-Reply-To: <f69b1c0c-fce3-c1c5-4eeb-7941028991de@univ-grenoble-alpes.fr>
References: <382b6f23-d36e-696a-a536-bb5c05b10d34@univ-grenoble-alpes.fr>
         <1512989520.22920.2.camel@suse.com>
         <1607480650.971508.1513000904833.JavaMail.zimbra@univ-grenoble-alpes.fr>
         <1513002580.22920.15.camel@suse.com>
         <1599416013.1022922.1513002815596.JavaMail.zimbra@univ-grenoble-alpes.fr>
         <1513004631.22920.20.camel@suse.com>
         <1847654838.1115072.1513006781751.JavaMail.zimbra@univ-grenoble-alpes.fr>
         <871008484.8702062.1520771930968.JavaMail.zimbra@univ-grenoble-alpes.fr>
         <CAHp75Vf0EWNzn+aRrg8XRZpKvmNMq=OXmLiW5FVGx+20xTvDuw@mail.gmail.com>
         <20180315114146.4qlfnxp3hc27oy4z@paasikivi.fi.intel.com>
         <f69b1c0c-fce3-c1c5-4eeb-7941028991de@univ-grenoble-alpes.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This laptop embeds one of these new "complex" cameras from Intel. They
requires IPU3 driver. Though, unlike traditional webcam, you need
special userspace to use it (there is no embedded firmware to manage
focus, whitebalance, etc, userspace code need to read the stats and
manage that). As of now, there is no good plan on how to support this
in userspace.

I have seen a lot of Intel engineer speak about GStreamer element
icamsrc, which would support this camera, but haven't seen any public
source code, so I can only assume it's all closed source. It's also of
limited use considering that browsers don't use GStreamer.

If I was to propose a plan, this should be integrated into Pipewire
daemon, which is upcoming userspace daemon to multi-plex notably
cameras across multiple process (a bit like pulseaudio for audio). It's
also the foreseen solution for sandboxed application that cannot
directly access any of the /dev, hence reserve forever a sesrouce like
a camera.

On Linux Desktop, this is a very bad launch, it will likely takes some
times before your camera works out of the box (if ever).

Nicolas

Le dimanche 01 avril 2018 à 18:17 +0200, Frédéric Parrenin a écrit :
> Dear Sakari et al.,
> 
> The acpi tables are apparently too big for the mailing lists.
> So I put the file here:
> https://mycore.core-cloud.net/index.php/s/DwTOb8TJJZYJtNe
> 
> Any information on what is going on with the webcams will be
> appreciated.
> 
> Thanks,
> 
> Frédéric
> 
> > 
> > Or drivers. And a bit more than that actually. Assuming this is
> > IPU3, that
> > is. If that's the case, the short answer is there's no trivial way
> > to
> > support webcam-like functionality using this device. The ACPI
> > tables would
> > tell more details.
> > 
> > Could you send me the ACPI tables, i.e. the file produced by the
> > command:
> > 
> > 	acpidump -o acpidump.bin
> > 
> > In Debian acpidump is included in acpica-tools package.
> > 
> > Thank you.
> > 
