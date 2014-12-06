Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:52207 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbaLFQsm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 11:48:42 -0500
Message-ID: <2eea6b3b11e395b7fb238f350a804dc9.squirrel@webmail.xs4all.nl>
Date: Sat, 6 Dec 2014 17:48:41 +0100
Subject: DVBSky T980C: Si2168 fw load failed
From: "Jurgen Kramer" <gtmkramer@xs4all.nl>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On my new DVBSky T980C the tuner firmware failes to load:
[   51.326525] si2168 2-0064: found a 'Silicon Labs Si2168' in cold state
[   51.356233] si2168 2-0064: downloading firmware from file
'dvb-demod-si2168-a30-01.fw'
[   51.408166] si2168 2-0064: firmware download failed=-110
[   51.415457] si2157 4-0060: found a 'Silicon Labs Si2146/2147/2148/2157/2158'
in cold state
[   51.521714] si2157 4-0060: downloading firmware from file
'dvb-tuner-si2158-a20-01.fw'
[   52.330605] si2168 2-0064: found a 'Silicon Labs Si2168' in cold state
[   52.330784] si2168 2-0064: downloading firmware from file
'dvb-demod-si2168-a30-01.fw'
[   52.382145] si2168 2-0064: firmware download failed=-110

110 seems to mean connection timeout. Any pointers how to debug this further?

This is with the latest media_build from linuxtv.org on 3.17.4.

Jurgen

