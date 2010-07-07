Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37547 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab0GGG6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 02:58:17 -0400
Received: by gye5 with SMTP id 5so2225890gye.19
        for <linux-media@vger.kernel.org>; Tue, 06 Jul 2010 23:58:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100707074431.66629934@tele>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Wed, 7 Jul 2010 02:57:54 -0400
Message-ID: <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 7, 2010 at 1:44 AM, Jean-Francois Moine <moinejf@free.fr> wrote:

> Hi Kyle,
>
> The problem is known. I have no fix yet, but it seems that you use a
> USB 1.1. or that you have some other device on the same bus. May you
> try to connect your webcam to an other USB port?
>
> Best regards.

I tested different ports, but the results are the same.

>From the log files it appears to be connecting via USB2.

Jul  7 01:48:54 kyleabaker-desktop kernel: [ 6186.202520] usb 2-1: new
full speed USB device using ohci_hcd and address 6
Jul  7 01:48:54 kyleabaker-desktop kernel: [ 6186.426975] gspca:
probing 045e:00f7
Jul  7 01:48:54 kyleabaker-desktop kernel: [ 6186.438792] sonixj:
Sonix chip id: 11
Jul  7 01:48:54 kyleabaker-desktop kernel: [ 6186.444844] input:
sonixj as /devices/pci0000:00/0000:00:02.0/usb2/2-1/input/input7
Jul  7 01:48:54 kyleabaker-desktop kernel: [ 6186.444916] gspca: video0 created
Jul  7 01:48:54 kyleabaker-desktop kernel: [ 6186.444918] gspca: found
int in endpoint: 0x83, buffer_len=1, interval=100

The only usb devices connected are my keyboard, mouse and vx-1000 webcam.

I can get the microphone back if I reset the modules:
sudo rmmod gspca_sonixj
sudo modprobe gspca_sonixj

If the microphone works when used alone (with the sound recorder
application) and video works in Cheese, why would they not work
together at the same time?

I'm looking through the sonixj.c code to see if I can find where its
breaking, but I'm not very experienced in C.

I've been trying to get this worked out for a year, so if there is
anything I can do to help fix this bug let me know. This is a fairly
common webcam, so it would be great to see this resolved soon.

What is the current priority of this bug?
-- 
Thanks,
Kyle Baker
