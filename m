Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm7-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.167]:32836 "EHLO
	nm7-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464Ab3FKIVZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 04:21:25 -0400
Message-ID: <1370938465.85106.YahooMailNeo@web125204.mail.ne1.yahoo.com>
Date: Tue, 11 Jun 2013 01:14:25 -0700 (PDT)
From: phil rosenberg <philip_rosenberg@yahoo.com>
Reply-To: phil rosenberg <philip_rosenberg@yahoo.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi this is my first email to the list, I'm hoping someone can help
I have a logitech C300 webcam with the option of raw/bayer output. This works fine on windows where the RGB output consists of zeros in the r and b bytes and pixel intensitey in the g byte. However on linux when I activate the webcam using uvcdynctrl and/or the options in guvcview the out put seems to be corrupted. I get something that looks like multiple images interlaces and displaced horizontally, generally pink. I've put an example of an extracted avi frame at http://homepages.see.leeds.ac.uk/~earpros/test0.png, which is a close up of one of my daughters hair clips and shows an (upside down) picture of a disney character.
I'm wondering if the UVC/V4L2 driver is interpretting the data as mjpeg and incorrectly decoding it giving the corruption. When I use guvcview I can choose the input format, but the only one that works in mjpeg, all others cause timeouts and no data. The image also has the tell-tale 8x8 jpeg block effect. Is there any way I can stop this decoding happening and get to the raw data? Presumably if my theory is correct then the decompression is lossy so cannot be undone.
Any help or suggestions welcome.

Phil
