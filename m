Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44452 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0FXUSx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 16:18:53 -0400
Received: by gye5 with SMTP id 5so4647968gye.19
        for <linux-media@vger.kernel.org>; Thu, 24 Jun 2010 13:18:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C238B30.3050908@opendot.cl>
References: <4C238B30.3050908@opendot.cl>
Date: Thu, 24 Jun 2010 17:18:52 -0300
Message-ID: <AANLkTilm8evyWV7hiP9f-Sb3DDKSGNpvqJXkZkm0hEuy@mail.gmail.com>
Subject: Re: ISDB-T Tuning
From: Alan Carvalho de Assis <acassis@gmail.com>
To: "Reynaldo H. Verdejo Pinochet" <reynaldo@opendot.cl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Reynaldo,

On 6/24/10, Reynaldo H. Verdejo Pinochet <reynaldo@opendot.cl> wrote:
> Hi guys
>
> I have been trying to get a siano based 1seg ISDB-T USB dongle
> to scan and tune under Linux to no avail. Asking around it has
> been brought to my attention there might be no app available
> that would do this successfully even with an adapter currently
> supported by the kernel like the one I'm using. Facing that
> scenario and assuming my lack of luck trying to find such an
> application supports that claim, I'm wondering if there is
> anyone reading this that might be working on writing such an
> application and/or in extending an existing one like 'scan'
> to be able to work with ISDB-T. Just to avoid duplicating the
> effort.
>

If you have all frequencies supported in your country you can the
"scan" command to detected all transmitted channels.

More info:
http://acassis.wordpress.com/2009/09/18/watching-digital-tv-sbtvd-in-the-linux/

Best Regards,

Alan
