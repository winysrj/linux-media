Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44199 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZIOTUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 15:20:38 -0400
Date: Tue, 15 Sep 2009 16:20:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-doc@vger.kernel.org
Subject: V4L/DVB API specifications at linux kernel
Message-ID: <20090915162002.1c72c5b3@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Something that always bothered me is that the documentation inside the kernel
for V4L/DVB were never properly updated, since people that write drivers in
general don't bother to keep the docs updated there. After some time, we've
removed V4L1 API from kernel (in text format, as far as I can remember), but
never added V4L2 API. Also, there weren't there any dvb api specs.

As an effort to change it, I did a work during the last few weeks to port V4L2 API
from DocBook v3.1 to DocBook XML v4.1.2. I also ported DVB specs from LaTex
into DocBook XML v4.1.2. This way, the API docs are compatible with the DocBook version
used in kernel (even eventually not having the same writing style as found there).

I tried to make the port as simple as possible, yet preserving the original
text. So, for sure there are space for style reviews, especially at the dvb
part, where the LaTex -> xml conversion were harder.

After having both ported, I've rearranged a few chapters and merged them
both into just one DocBook book, to allow having some parts shared, like IR.

The final document were broken into 3 parts:
I. Video for Linux Two API Specification
	(basically, the same contents found at V4L2 spec version 2.6.32, except for IR chapter)
II. Linux DVB API
	(basically, the same contents found at DVB spec version 3)
III. Other API's used by media infrastructure drivers
	(basically, the IR chapter taken from V4L2 spec)

The resulting html pages can be seen at: http://linuxtv.org/downloads/v4l_dvb_apis/

The Kernel patches with the Document are at:

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=9444a960e4c7c49e055bb7fa66a0805c46317ba0
http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=664efd3215fdb17d5f3f70073af4a6b61d50a96c

Please review. If they're ok, I'm intending to submit them for addition at 2.6.32.

Cheers,
Mauro
