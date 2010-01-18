Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36931 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0ARL0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 06:26:13 -0500
Received: by fxm25 with SMTP id 25so329724fxm.21
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 03:26:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100118103331.GA13882@seneca.muc.de>
References: <20100118103331.GA13882@seneca.muc.de>
Date: Mon, 18 Jan 2010 15:20:12 +0400
Message-ID: <1a297b361001180320i705ee3c3ice36805c392e2502@mail.gmail.com>
Subject: Re: [linux-dvb] s2-liplianin & Technotrend TT-Connect S-2400
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 18, 2010 at 2:33 PM, Harald Milz <hm@seneca.muc.de> wrote:
> Hi,
>
> I am trying to use a S-2400 for Hotbird in addition to 2 S2-3650's pointing at
> Astra. For the 3650's I need to use s2-liplianin because the box is not yet
> supported by my stock OpenSUSE 11.1 (update) kernel. The 3650's work fine so
> far. I have no luck with the 2400, though. Attached is the syslog excerpt -
> maybe someone can see what is wrong here. The driver code is s2-liplianin-head
> from last Saturday.
>
> Shortcut question: Do I want to get another 3650 / 3600? I had no luck with a
> quad monoblock LNB either...


I think the ttusb2 driver from http://linuxtv.org/hg/v4l-dvb  would
work with regards to the S-2400.


Regards,
Manu
