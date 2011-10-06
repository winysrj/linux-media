Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58030 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab1JFOjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 10:39:19 -0400
Received: by gyg10 with SMTP id 10so2632738gyg.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 07:39:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110061623.13253.liplianin@me.by>
References: <CABHmaNMw8OUoSZ8XsWA_QQz5H9h6+3aVTVMcW30VzOCGTx7=gw@mail.gmail.com>
 <201110061623.13253.liplianin@me.by>
From: Evan Platt <evplatt@gmail.com>
Date: Thu, 6 Oct 2011 09:38:58 -0500
Message-ID: <CABHmaNPGgz9s+S1Ej0HCiCmE8_5oCet0qfAS755smE7MApv0xQ@mail.gmail.com>
Subject: Re: Media_build Issue with altera on cx23885
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Mauro Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
	Abylai Ospan <aospan@netup.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for the patch!  I see the drivers/misc path wasn't yet added
to the Makefile.

The build process completed and the driver loads correctly as far as I
can tell.  The frontend is still failing to initialize, but at least I
have a new problem to chase.  Thanks again!

Evan

On Thu, Oct 6, 2011 at 8:23 AM, Igor M. Liplianin <liplianin@me.by> wrote:
> ÷ ÓÏÏÂÝÅÎÉÉ ÏÔ 5 ÏËÔÑÂÒÑ 2011 23:04:34 Á×ÔÏÒ Evan Platt ÎÁÐÉÓÁÌ:
>> V4L-DVB was previously working correctly for me. šI was experiencing
>> some problems which had been solved before by recompiling v4l. šSo I
>> cloned the latest media_build tree and ran the build process.
>>
>> Afterward, the driver does not load correctly and dmesg shows an error
>> (cx23885: Unknown symbol altera_init (err 0)). šI know there was a
>> change to move altera from staging to misc but I see that the changes
>> were propogated to media_build on 9/26/11.
>>
>> I ran menuconfig and made sure that MISC_DEVICES was set to 'y' to
>> include altera-stapl but to no avail.
>>
>> Please advise.
>>
>> Some relevant information:
>>
>> Device: šHauppauge HVR-1250 Tuner
>> Driver: šcx23885
>> Environment: Ubuntu 11.04, 2.6.38-11-generic
>>
>> Thanks!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Hi Evan,
> Just try attached patch against media_build. It fixes altera-stapl build for
> media_build tree.
>
> Mauro, is this a correct patch?
>
> --
> Igor M. Liplianin
> Microsoft Windows Free Zone - Linux used for all Computing Tasks
>
