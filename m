Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53507 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZJXINM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 04:13:12 -0400
Received: by ewy4 with SMTP id 4so2266187ewy.37
        for <linux-media@vger.kernel.org>; Sat, 24 Oct 2009 01:13:16 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 24 Oct 2009 11:13:16 +0300
Message-ID: <b28850b10910240113n29e905cx4c9927fc2196f97@mail.gmail.com>
Subject: em28xx: new board id [eb1a:e323]
From: =?KOI8-U?B?4s/HxMHOIPDB0sHOycPR?= <bogdan.paranitca@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've made tests with my Kworld board:

Model: DVB-T 323U
Vendor/Product id: [eb1a:e323].

Test made:

    - Analog [Worked]
    - DVB [not tested]

Sound works with `arecord -v -D hw:1,0 -r 48000 -c 2 -f S16_LE | aplay
-Dplug:surround51` hint.

Tested-by: bogdan.paranitca <bogdan.paranitca@gmail.com>
