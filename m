Return-path: <linux-media-owner@vger.kernel.org>
Received: from 83-103-0-23.ip.fastwebnet.it ([83.103.0.23]:57846 "EHLO
	motoko.logossrl.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566AbaIATCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 15:02:51 -0400
Received: from host62-132-dynamic.11-87-r.retail.telecomitalia.it ([87.11.132.62] helo=aika.discordia.loc)
	by motoko.logossrl.com with esmtpsa (UNKNOWN:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.80.1)
	(envelope-from <l.marcantonio@logossrl.com>)
	id 1XOWsG-00061C-Ol
	for linux-media@vger.kernel.org; Mon, 01 Sep 2014 21:02:45 +0200
Date: Mon, 1 Sep 2014 21:03:02 +0200
From: Lorenzo Marcantonio <l.marcantonio@logossrl.com>
To: linux-media@vger.kernel.org
Subject: Re: strange empia device
Message-ID: <20140901190301.GA3762@aika.discordia.loc>
References: <20140825190109.GB3372@aika.discordia.loc>
 <5403358C.4070504@googlemail.com>
 <54033620.4000105@googlemail.com>
 <20140831154127.GA15276@aika.discordia.loc>
 <5404B781.9020702@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5404B781.9020702@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 01, 2014 at 08:14:25PM +0200, Frank Schäfer wrote:

> What's the other device using this vid:pid and which hardware does it use ?

The previous generation of the tool:

http://www.linuxtv.org/wiki/index.php/RoxioEasyVHStoDVD

... an easycap DC60+ clone. Doubly hating it since I bought is sure that
it would have been supported!

> The big task is the integrated decoder. Makes no fun without a datasheet. :/

I presume that with decoder you mean the composite to YUV translator... With the datasheet is too easy :D strange thing is eMPIA says that linux
is supported for some of their chip. But of course the 2980 isn't even
advertised and probably they only give you docs if you buy 100K pieces:(

> Thanks, looks like the other em2980 we have seen (Dazzle Video Capture
> USB V1.0).

Please tell if there are other tests or captures you need. By the way,
even on Windows, transfer seems flaky. If the bus is not perfectly
idle or there is some nontrivial CPU load often it loses transfer sync
and the image get "split" (probably an isoc transfer get lost and it
doesn't number the packets or something). Had the same problem with the
other chinese camera I used (USB suckitude knows no limits:P)

-- 
Lorenzo Marcantonio
Logos Srl
