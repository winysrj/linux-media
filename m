Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61232 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab1LHBgO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 20:36:14 -0500
Received: by wgbdr13 with SMTP id dr13so2336373wgb.1
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2011 17:36:13 -0800 (PST)
Message-ID: <4EE0148A.9000101@gmail.com>
Date: Thu, 08 Dec 2011 02:36:10 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/1] xc3028: force reload of DTV7 firmware in VHF band
 with Zarlink demodulator
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 07/12/2011 22:54, Christoph Pfister ha scritto:
> 2011/12/7 Mauro Carvalho Chehab <mchehab@redhat.com>:
> <snip>
>> Several channels in Italy are marked as if they are using 8MHz for VHF (the
>> auto-Italy is
>> the most weird one, as it defines all VHF frequencies with both 7MHz and
>> 8MHz).
> 
> Well, auto-Italy is a superset of the it-* files. For example "T
> 177500000 7MHz" exists in some files (Modena, Montevergina) and "T
> 177500000 8MHz" in others (Sassari), so both possibilities have to
> appear in auto-Italy (similar for other VHF frequencies, it simply
> doesn't seem to be regulated). There's nothing to fix there,
> auto-Italy exists exactly because of these irregularities.
> 
> <snip>
> 
> Christoph
> 

Hi Christoph,
since June 2009 all VHF channels in Italy use the European canalization,
which means there is no 8 MHz VHF channel anymore.

The data you have are outdated.

If you need some reliable reference to know what is broadcasted in
Italy, the best available source is this amatory website:

http://www.otgtv.it/index2.html

It is maniacally maintained by a single person, which is a real
enthusiast of TV broadcasting and has access to reliable first-hand
informations. There are also a few institutional websites, but they can
not compete with this site in terms of accuracy.

The auto-Italy table for DVB-T should be just:

VHF:
channels 5-12 with 7 MHz bandwidth;
UHF:
channels 21-69 with 8 MHZ bandwidth;

The last 6 regions will switch-off analog broadcasting in the first half
of 2012 (Abruzzo, Molise, Puglia, Basilicata, Calabria, Sicilia).
Until then, there are a few analog channels using some weird frequency
table, but all digital multiplexes are already converted to the new
European frequency table.

Best,
Gianluca



