Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38845 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2BFJOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 04:14:05 -0500
Received: by bkcjm19 with SMTP id jm19so4478157bkc.19
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2012 01:14:03 -0800 (PST)
Message-ID: <4F2F99D9.6070206@googlemail.com>
Date: Mon, 06 Feb 2012 10:14:01 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: If you own an ASUS notebook, please test latest v4l-utils
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm Gregor a co-maintainer of v4l-utils. As you might know most (all?) 
ASUS notebooks have their webcams built in upside down. Libv4l (which is 
part of v4l-utils) has an internal notebook model table to detect such 
notebooks and flip the image if necessary.

Recently I rewrote the matching algorithm to only match the chassis type 
and chassis version and discard things like chipset type. This way we 
hope to reduce the upside down table update frequency.

If you own an ASUS notebook and have five minutes time to spare, please 
test the changes on your machine:

1. Download v4l-utils snapshot:
wget http://alioth.debian.org/~gjasny-guest/v4l-utils-0.9.0-test1.tar.bz2

2. Install prerequisites: A C++ compiler, qt4 and libjpeg development 
headers

3. Extract and build tarball
cd v4l-utils-0.9.0-test1
./configure
make

4. Run qv4l2 and check that the image is not upside down:
utils/qv4l2/qv4l2
Start Capturing (big red botton)

5. Report any flipped images to me. Please include the content of
/sys/class/dmi/id/board_name

Thanks for your help,
Gregor
