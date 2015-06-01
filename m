Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.CARNet.hr ([161.53.123.6]:49303 "EHLO mail.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbFAMWS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 08:22:18 -0400
Received: from cnzgrivvl3.carpriv.carnet.hr ([161.53.12.131]:39210 helo=gavran.carpriv.carnet.hr)
	by mail.carnet.hr with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <Valentin.Vidic@CARNet.hr>)
	id 1YzOjQ-0002j3-3h
	for linux-media@vger.kernel.org; Mon, 01 Jun 2015 14:22:16 +0200
Date: Mon, 1 Jun 2015 14:22:15 +0200
From: Valentin Vidic <Valentin.Vidic@CARNet.hr>
To: linux-media@vger.kernel.org
Message-ID: <20150601122215.GD1807@gavran.carpriv.carnet.hr>
References: <20150528144117.GP1807@gavran.carpriv.carnet.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150528144117.GP1807@gavran.carpriv.carnet.hr>
Subject: Re: Issues with Geniatech MyGica T230
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 28, 2015 at 04:41:17PM +0200, Valentin Vidic wrote:
> I recently bought this card after seeing on the LinuxTV wiki
> that it's supported since kernel v3.19, but now I can't get
> it working properly with Debian.  The modules load without
> errors but scanning for channels or watching TV does not
> work reliably: some channels work but others just hang the
> player or return a lot of "frame out of order erorrs". 
> 
> In order to rule out hardware problems I tested the card
> using OpenELEC (RPi and x86_64) and Windows Media Player
> and it works there without a glich.  So I assumed this is
> a software problem somewhere I tried several different
> kernel versions without success:
> 
> 3.16.7-ckt9-3~deb8u1 + media_build drivers
> 4.0.2-1
> 3.19.0
> 3.19.8

Any suggestions what could be wrong or what more to try? 

-- 
Valentin
