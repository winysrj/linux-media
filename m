Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp47.i.mail.ru ([94.100.177.107]:51721 "EHLO smtp47.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbFGUzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 16:55:16 -0400
Message-ID: <C6841AEECECB40A2A9A6CDB7320309F9@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: <linux-media@vger.kernel.org>, "Hurda" <hurda@chello.at>
References: <0448C37B97FE43E6A8CD61968C10E73F@unknown> <55733133.6050502@iki.fi> <CFB6F14A3740441FB49C6FF2FC3CAD56@unknown> <557354A2.7060900@iki.fi> <D91B54BF334446CEAB709731EE051752@unknown> <557494E1.3060403@chello.at>
Subject: Re: Si2168 B40 frimware.
Date: Mon, 8 Jun 2015 03:55:08 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hurda,

> What's new with that firmware?
> It's twice as big as 4.0.11, so there got to be a lot of changes and fixes.
I can't tell exactly what 4.0.19 does. May be I'm wrong, but I suppose, patch 4.0.19
for B40 has so big size, because most likely it resolves the same issues as patch 3.0.20 for A30:
Here, in Russia, TV broadcasters actively using Multi PLP in DVB-T2 transmissions.
In some cities, were problems with switching to PLP#1 or PLP#2 without A30 3.0.20 patch.
(Different cities in different time zones lead to a separate mux transport streams for them.)

What I can tell exactly, is that A30 3.0.20 contains an update for Si2168, which allows
demodulator to lock PLP#2 with an "old" type OFDM frame encoding. Also it speed up locking
for low bitrates PLP.
In short: it fixes a serious issue with Multi PLP locking.
 
> I assume the info originates from 
> http://beholder.ru/bb/viewtopic.php?f=11&t=14101 , but I don't understand 
> Russian at all.
Yes, you are right.

Best regards.
