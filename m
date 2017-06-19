Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45608
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750780AbdFSRIO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 13:08:14 -0400
Date: Mon, 19 Jun 2017 14:08:06 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Thierry Lelegard <thierry.lelegard@free.fr>
Cc: thierry@lelegard.fr, linux-media@vger.kernel.org
Subject: Re: LinuxTV V3 vs. V4 API doc inconsistency, V4 probably wrong
Message-ID: <20170619140806.7e92ae66@vento.lan>
In-Reply-To: <3188f2a2bcba758dccaaa8cdbbd694fb@free.fr>
References: <3188f2a2bcba758dccaaa8cdbbd694fb@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Jun 2017 16:58:40 +0200
Thierry Lelegard <thierry.lelegard@free.fr> escreveu:

> Hi,

First of all, there's no Linux DVB API v4. It was skipped, because there
was a proposal for a v4, with was never adopted.

> 
> There is an ambiguity in the LinuxTV documentation about the following 
> ioctl's:
> 
>     FE_SET_TONE, FE_SET_VOLTAGE, FE_DISEQC_SEND_BURST.
> 
> These ioctl's take an enum value as input. In the old V3 API, the 
> parameter
> is passed by value. In the S2API documentation, it is passed by 
> reference.
> Most sample programs (a bit old) use the "pass by value" method.
> 
> V3 documentation: https://www.linuxtv.org/docs/dvbapi/dvbapi.html
>     int ioctl(int fd, int request = FE_SET_TONE, fe_sec_tone_mode_t 
> tone);
>     int ioctl(int fd, int request = FE_SET_VOLTAGE, fe_sec_voltage_t 
> voltage);
>     int ioctl(int fd, int request = FE_DISEQC_SEND_BURST, 
> fe_sec_mini_cmd_t burst);
> 
> S2API documentation: 
> https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/dvb/frontend_fcalls.html
>     int ioctl(int fd, FE_SET_TONE, enum fe_sec_tone_mode *tone)
>     int ioctl(int fd, FE_SET_VOLTAGE, enum fe_sec_voltage *voltage)
>     int ioctl(int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd *tone)

Thanks for reviewing it! Yeah, the asterisks there are wrong.
The definitions should be, instead:

     int ioctl(int fd, FE_SET_TONE, enum fe_sec_tone_mode tone)
     int ioctl(int fd, FE_SET_VOLTAGE, enum fe_sec_voltage voltage)
     int ioctl(int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd tone)

As they're passing by value, not by reference[1].

Feel free to send us fix patches.

Thanks,
Mauro
