Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:33007 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1431518AbdDYOPH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 10:15:07 -0400
Received: by mail-pg0-f49.google.com with SMTP id 63so29312835pgh.0
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 07:15:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKXQXwKeA6YCaepmjJJBf+Nc3bOO9aEnGmnHfnb2aDX3f6YXzw@mail.gmail.com>
References: <CAOxqCCT6MOCLG+HHsuOU0zoq1zxRRJNFn0DYz9tOj-ez7+BNRA@mail.gmail.com>
 <CAAEAJfC0MdO2Uy8P0OajRHEc3seUiwLv0qqxLzM3b9eFFfuk8g@mail.gmail.com>
 <1493030334.2891.7.camel@pengutronix.de> <CAKXQXwLuG1A37NTPrE0abPWhMDGd=10Ud+xNa-4+k+8qMhD8tA@mail.gmail.com>
 <CAKXQXwKeA6YCaepmjJJBf+Nc3bOO9aEnGmnHfnb2aDX3f6YXzw@mail.gmail.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Tue, 25 Apr 2017 11:15:06 -0300
Message-ID: <CAAEAJfBEqFYtKLHuNBBbc8+RteM8rhRNs3PFvAnGsVWRpxEGNw@mail.gmail.com>
Subject: Re: TW686x Linux Main Line Driver Issue
To: Krishan Nilanga <krishan@tengriaero.com>
Cc: Lucas Stach <l.stach@pengutronix.de>,
        Anuradha Ranasinghe <anuradha@tengriaero.com>,
        linux-media <linux-media@vger.kernel.org>,
        Lakshitha Dayasena <lakshitha@tengriaero.com>,
        linux-pci@vger.kernel.org, Richard.Zhu@freescale.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krishan,

On 25 April 2017 at 03:46, Krishan Nilanga <krishan@tengriaero.com> wrote:
> Hi All,
>
> gst-launch-1.0 --gst-debug=3D3 v4l2src device=3D/dev/video0 !
> video/x-raw,width=3D640,height=3D480,pixelformat=3DUYVY ! imxeglvivsink
>
> I have tried to run the above gstreamer pipeline and I'm getting
>
> [   97.392807] tw686x 0000:01:00.0: DMA timeout. Resetting DMA for all
> channels
> [   97.392827] tw686x 0000:01:00.0: reset: stopping DMA
>
> for most IRQ calls of tw686x driver.
>
> for some other IRQ calls I'm getting
>
> [   99.592901] tw686x 0000:01:00.0: video0: unexpected p-b buffer!
> [   99.592924] tw686x 0000:01:00.0: reset: stopping DMA
>
> in dmesg.
>
> I hope above details will help to understand the problem.
>

This does not provide much info. It merely says there is some hardware
problem or the signal is being problematic. FWIW, when we get those
messages on our platform it's always correlated to a bad cable
or poor signal.

What is your dma-mode configuration?
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
