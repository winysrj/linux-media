Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41274 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1JNMv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 08:51:59 -0400
Received: by bkbzt4 with SMTP id zt4so2760332bkb.19
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 05:51:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E982CE7.6030203@poczta.onet.pl>
References: <4E273AB5.7090405@poczta.onet.pl>
	<201110140927.23067.hselasky@c2i.net>
	<4E982CE7.6030203@poczta.onet.pl>
Date: Fri, 14 Oct 2011 08:51:57 -0400
Message-ID: <CAGoCfiwysaB5x9Ojrnmgi-4VWVBu-exv1O2Hv+U3_hpROO6a_w@mail.gmail.com>
Subject: Re: [PATCH] dvb/as102 nBox DVB-T dongle
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Hans Petter Selasky <hselasky@c2i.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 14, 2011 at 8:36 AM, Piotr Chmura <chmooreck@poczta.onet.pl> wrote:
> Hi,
>
> There's  licencing problem with as10x_cmd_cfg.c and as10x_cmd_stream.c files
> which are not GPL ( (c) Copyright Abilis Systems SARL 2005-2009 All rigths
> reserved \n
>   www.abilis.com).
>
> Dunno if it's only Davin's Heitmueller oversight in changing licencing or a
> real problem.
> What about it Davin ?

Yeah, those were an oversight on the part of Abilis.  I already talked
to them about it and got permission to fix the text.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
