Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:57066 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1LBSDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2011 13:03:33 -0500
Received: from basile.remlab.net (cs27062010.pp.htv.fi [89.27.62.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by yop.chewa.net (Postfix) with ESMTPSA id 36DD611B8
	for <linux-media@vger.kernel.org>; Fri,  2 Dec 2011 19:03:32 +0100 (CET)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: LinuxTV ported to Windows
Date: Fri, 2 Dec 2011 20:03:28 +0200
References: <4ED65C46.20502@netup.ru> <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com>
In-Reply-To: <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112022003.28737.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hello,

A GPL troll, as the "Vicious Nokia Employee [that got] VLC Removed from Apple 
App Store" I cannot resist...

Le mercredi 30 novembre 2011 19:23:26 Devin Heitmueller, vous avez écrit :
> Am I the only one who thinks this is a legally ambigious grey area?
> Seems like this could be a violation of the GPL as the driver code in
> question links against a proprietary kernel.

If you have any doubt, I would suggest you ask the SFLC. They tend to give 
valuable insights into that sort of problems. It might be intricate and/or not 
what you want to hear from them though (Been there done that).

> I don't want to start a flame war, but I don't see how this is legal.
> And you could definitely question whether it goes against the
> intentions of the original authors to see their GPL driver code being
> used in non-free operating systems.

As long as the distributed binaries do not include any GPL-incompatible code 
(presumably from Microsoft), there should be no GPL contamination problem. So 
it boils down to whether the driver binary has non-GPL code in it. I don't see 
how the license of the Windows code is relevant, so long as NetUp is not 
distributing the Windows OS alongside the driver (or vice versa).

And while I do not know the Windows DDK license, I doubt it cares much about 
the driver license, so long as Microsoft does not need to distribute nor 
certify the driver.


There may however be problems with the toolchain. The driver binary must be 
recompilable with just the GPL'd source code and "anything that is normally 
distributed with the operating system". VisualStudio is not distributed with 
Windows. In fact, it is sold as a separate product, except for restrictive 
freeware versions.

So unless this driver can be compiled with a GPL-compatible toolchain (and the 
toolchain is provided by NetUp), it might not be possible to distribute binary 
copies of the driver.

Then again, I am not a laywer. Someone that cares, please ask SFLC or friends.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
