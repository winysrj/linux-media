Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61690 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZIQMxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 08:53:40 -0400
Received: by ewy2 with SMTP id 2so354340ewy.17
        for <linux-media@vger.kernel.org>; Thu, 17 Sep 2009 05:53:43 -0700 (PDT)
Message-ID: <4AB23151.6090409@gmail.com>
Date: Thu, 17 Sep 2009 14:53:37 +0200
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: claesl@gmail.com
Subject: Nova S2 HD scanning problems
References: <200909100913.09065.hverkuil@xs4all.nl>	<20090916175043.0d462a18@pedra.chehab.org>	<A69FA2915331DC488A831521EAE36FE40155157118@dlee06.ent.ti.com>	<200909170834.23449.hverkuil@xs4all.nl> <20090917091104.34806d1e@pedra.chehab.org>
In-Reply-To: <20090917091104.34806d1e@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
I have just installed my new Nova S2 HD card on ubuntu x86_64, 
2.6.28-13-generic, changed the
firmware to version 1.23.86.1 and I have also tried version 1.22.82.0. 
The result is that I can tune and watch
channels without any problems but when I try to scan for channels it 
will not work.

The card is loaded as adapter 1 so I use the following command to scan 
with the latest scan-s2
sudo ./scan-s2 -a 1 -s 0 -l UNIVERSAL dvb-s/Thor-1.0W

I have a DisEqC switch but I know it's working since I have a Azurewave 
AD SP400 card that I have scanned channels before
and also the card can tune in on both LNB's with szap-s2.

Has anyone ideas about the scanning problems?

Dmesg does not output anything.
Output of scan-s2:
----------------------------------> Using DVB-S
 >>> tune to: 11216:vC78S0:S0.0W:24500:
DVB-S IF freq is 1466000
WARNING: >>> tuning failed!!!
 >>> tune to: 11216:vC78S0:S0.0W:24500: (tuning failed)
DVB-S IF freq is 1466000
WARNING: >>> tuning failed!!!
----------------------------------> Using DVB-S2
 >>> tune to: 11216:vC78S1:S0.0W:24500:
DVB-S IF freq is 1466000
WARNING: >>> tuning failed!!!
 >>> tune to: 11216:vC78S1:S0.0W:24500: (tuning failed)
DVB-S IF freq is 1466000
WARNING: >>> tuning failed!!!


Regards
/Claes

