Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49252 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2LJUIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 15:08:20 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so2023139qaq.19
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 12:08:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C638C7.10200@googlemail.com>
References: <50C638C7.10200@googlemail.com>
Date: Mon, 10 Dec 2012 15:08:19 -0500
Message-ID: <CAGoCfiwUkhVBwgykXTAb01gQ-p6ebzoh0JZDge7uPrnhhRv6CQ@mail.gmail.com>
Subject: Re: EM2800 and audio via USB ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 10, 2012 at 2:32 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> a Terratec Cinergy 200 USB

Most of those really old devices don't actually make the PCM audio
available over the USB.  That's why they provide an "audio out"
connector - you're supposed to connect it to the line-in on your sound
card.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
