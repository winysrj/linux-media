Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46895 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0E0OZA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 10:25:00 -0400
Received: by wyb29 with SMTP id 29so4224351wyb.19
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 07:24:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinC37We1AuamrP07ALJ87wtmKnb3_UHF6yr9q0m@mail.gmail.com>
References: <4BFC4858.8060403@helmutauer.de>
	<4BFD8388.9060904@helmutauer.de>
	<AANLkTilEotbTzCqAXn9K53phzQmFWKM03icjWECaowPv@mail.gmail.com>
	<AANLkTinC37We1AuamrP07ALJ87wtmKnb3_UHF6yr9q0m@mail.gmail.com>
Date: Thu, 27 May 2010 18:54:59 +0430
Message-ID: <AANLkTinhTfpPV_HxChy9uhjzQy2xcHnz1fqs05zl_Bux@mail.gmail.com>
Subject: Re: v4l-dvb does not compile with kernel 2.6.34
From: Nima <nima.irt@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Last week I had the same problem. It gave me a headache trying to make
it work! So here is the instruction:

* First, follow the link below and download the .bz2 file.
http://mercurial.intuxication.org/hg/s2-liplianin

*Now, extract the files in the /usr/src/ directory and then, at the
prompt, type the following command:

wget "http://www.forum.free-x.de/wbb/index.php?page=Attachment&attachmentID=479&h=4f8e50d771ca4d3cd5d2fe38c7afe772c373313f"
-O SVT-SkyStarS2-driver-install.run.tar.bz2

*Extract the downloaded file and execute the ".run" file to patch the
v4l-dvb source code which you've downloaded by the first command.
./SVT-SkyStarS2-driver-install.run

Now, if it is patched correctly, you'll be able to run make and make
install. And that's it!

*You may encounter errors concerning a function named kzalloc. Let me
know if the compiling error occurred for you.

--
Yours sincerely,
Nima Mohammadi
