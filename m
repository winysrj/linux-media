Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760197Ab3DBONO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Apr 2013 10:13:14 -0400
Message-ID: <515AE84A.5030504@redhat.com>
Date: Tue, 02 Apr 2013 16:16:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: bernhardout@lsmod.de
Subject: Announce: xawtv-3.103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm happy to announce the latest xawtv release

Changes:

3.103
=====
* Improve alsa stream handling
* Add support for alsa audio loopback to the radio app
* Add support for multiple-band (AM+FM) tuners to radio app
* Tons of other bugfixes + improvements for the radio app
* Fix xawtv window flashing to black when changing channel or taking a snapshot
* Fix crackle crackle sound on mp34xx cards when changing channel
* Various other bugfixes

Grab it here:
http://linuxtv.org/downloads/xawtv/xawtv-3.103.tar.bz2

Regards,

Hans
