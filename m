Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40300 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1H2OVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 10:21:18 -0400
Received: by wyg24 with SMTP id 24so4104701wyg.19
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 07:21:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+s_+RpekDfRSWEQMZObjiR-RTgLeFUk1tc-g6ieQYLzcTqwdw@mail.gmail.com>
References: <CA+s_+RqtWZuj5b55Vk5A==VqbPEnDoqFfSVGtA2n-pdR85mc8g@mail.gmail.com>
	<CA+s_+RrGE2T0H+XSSjg81zh514g1oQePLCfV-y3nJC8DqXjWjQ@mail.gmail.com>
	<CA+s_+RpekDfRSWEQMZObjiR-RTgLeFUk1tc-g6ieQYLzcTqwdw@mail.gmail.com>
Date: Mon, 29 Aug 2011 11:20:56 -0300
Message-ID: <CAG4Y6eTVzx-jwkzQzR97stabE6KEGh5HGD7UaWnxM333Z3iqxg@mail.gmail.com>
Subject: Re: Usb digital TV
From: Alan Carvalho de Assis <acassis@gmail.com>
To: Gabriel Sartori <gabriel.sartori@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gabriel,

On 8/29/11, Gabriel Sartori <gabriel.sartori@gmail.com> wrote:
> It there some devices that has more chance to work on a 2.6.35 kernel
> version so I can just cross compile the driver to my mx28 board in a
> easier way?
>
> Thanks in advance.
>

I suggest you using a device based on dib0700, I got it working on
Linux <= 2.6.35:
https://acassis.wordpress.com/2009/09/18/watching-digital-tv-sbtvd-in-the-linux/

This same device working on i-MXT (Android 2.2 with Linux kernel 2.6.35):
http://holoscopio.com/misc/androidtv/

Best Regards,

Alan
