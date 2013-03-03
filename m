Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:38003 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3CCH1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 02:27:35 -0500
Received: by mail-ve0-f171.google.com with SMTP id b10so3910744vea.16
        for <linux-media@vger.kernel.org>; Sat, 02 Mar 2013 23:27:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <dc3dda23a470964879907df16f64bc53@beep.pl>
References: <dc3dda23a470964879907df16f64bc53@beep.pl>
Date: Sun, 3 Mar 2013 12:57:34 +0530
Message-ID: <CAHFNz9KqOkSi2BcxU5ZbPnJgu4QsUFbqhnShGrsLXv-C1um82A@mail.gmail.com>
Subject: Re: linux-dvb: scan util fix
From: Manu Abraham <abraham.manu@gmail.com>
To: j.uzycki@elproma.com.pl
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/28/13, j.uzycki@elproma.com.pl <j.uzycki@elproma.com.pl> wrote:
> Hi.
>
> I found a problem with scan and DVBS. When I research the transponder
> S13E0, freq. ~11471MHz, polar. V, symrate 27500 (scan -c -a 3) I get
> "WARNING: section too short: service_id == 0x669, section_length == 764,
> descriptors_loop_len == 0" (scan_notpatched.output). VLC shows more
> channels / services. The problem is null descriptors_loop_len inside of
> SDT. However no descriptors of a service do not mean end of service
> list. I didn't find nothing about it in the spec. So it seems a little
> bug.
>
> When I applied my simple patch scan_sdt_test.patch I got rest of names
> of the services (scan_patched_test.output).
> The final simplest patch is scan_sdt.patch (scan_patched.output
> corresponds).
>
> The patch is not signed-off because I don't know hg/Mercurial enough
> yet.

Thanks. Applied.

Manu
