Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:47699 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaKTTwG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 14:52:06 -0500
Received: by mail-la0-f46.google.com with SMTP id gd6so3025270lab.5
        for <linux-media@vger.kernel.org>; Thu, 20 Nov 2014 11:52:04 -0800 (PST)
Date: Thu, 20 Nov 2014 21:51:58 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: =?ISO-8859-15?Q?=C9der_Zsolt?= <zsolt.eder@edernet.hu>
cc: linux-media@vger.kernel.org
Subject: Re: SAA7164 firmware for Asus MyCinema
In-Reply-To: <546C5494.4000908@edernet.hu>
Message-ID: <alpine.DEB.2.10.1411202148420.1388@dl160.lan>
References: <546C5494.4000908@edernet.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-634191264-1416513123=:1388"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-634191264-1416513123=:1388
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 19 Nov 2014, Éder Zsolt wrote:

> Hi,
>
> I found at the site: http://www.linuxtv.org/wiki/index.php/ATSC_PCIe_Cards 
> that if I have a TV-tuner card which is currently unsupported, you may help 
> me how I can make workable this device.
>
> I have an Asus MyCinema EHD3-100/NAQ/FM/AV/MCE RC dual TV-Tuner card with 
> SAA7164 chipset.

Did we talk about this in IRC a couple of days ago?

If not, you will need to find out which demodulator and tuner are used on 
that card. You can find those by looking at the physical card. Read the 
text on the bigger ICs and try to put them in the google to find out the 
components used. The tuner might be under metal shielding, in which case 
it might be a bit more tricky to find out.

Looking at the files in the Windows driver package might give you some 
hints as well.

Cheers,
-olli
--8323329-634191264-1416513123=:1388--
