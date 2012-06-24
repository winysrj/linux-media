Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53221 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2FXU1G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 16:27:06 -0400
Received: by wgbdr13 with SMTP id dr13so3428048wgb.1
        for <linux-media@vger.kernel.org>; Sun, 24 Jun 2012 13:27:04 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 Jun 2012 22:27:04 +0200
Message-ID: <CABKcTNpNCKSQxHUtsB_Q=ZeHptL1w0hQPtkfQRvF5abKZwABww@mail.gmail.com>
Subject: homebrew versatile set top box
From: Sebastiano Fabio Genovese <synapse@videobank.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
excuse my poor English, since a month I'm thinking of developing a
new, homebrew, dvb platform based on tu1216l tuner (DVB-T tda10046
Channel Receiver and PLL synthesizer for hybrid terrestrial tda6650
tuner). I found the datasheet in a very difficult, trying for weeks,
but now I have: I have not signed any nda ;)

my goals is provide cheap and  free to build:
- dvb usb stb
- sprectrum analyzer
- field measurer
- radioastronomy equipment
- and so on..

in the future would also be possible to replace the tuner with a
satellite type and extend the functionality, allowing datv receiving,
and more.

Now I'm considering whether to use the classic CYPRESS FX2, covered by
rights (including the tuner is, but they all are!),  or use FT2232, I
have seen to be sufficiently fast and versatile, someone confirm my
theory.

For the electronic part I am able to complete the project in its
entirety, for software I would have some difficulty, as I should be
studying very hard for months because I have no experience in
developing kernel driver, especially the difficulty of v4l.

I thank all those who can help me or give me a simple piece of advice,
Thanks in advance,
Genovese Fabio
