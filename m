Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:36196 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1FTRhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 13:37:24 -0400
Received: from basile.remlab.net (cs27062010.pp.htv.fi [89.27.62.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by yop.chewa.net (Postfix) with ESMTPSA id 1EC91140
	for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 19:37:23 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc - virtual DVB device driver
Date: Mon, 20 Jun 2011 20:37:18 +0300
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
In-Reply-To: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106202037.19535.remi@remlab.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

	Hello,

Le dimanche 19 juin 2011 03:10:15 HoP, vous avez écrit :
> get inspired by (unfortunately close-source) solution on stb
> Dreambox 800 I have made my own implementation
> of virtual DVB device, based on the same device API.

Some might argue that CUSE can already do this. Then again, CUSE would not be 
able to reuse the kernel DVB core infrastructure: everything would need to be 
reinvented in userspace.

> In conjunction with "Dreamtuner" userland project
> [http://code.google.com/p/dreamtuner/] by Ronald Mieslinger
> user can create virtual DVB device on client side and connect it
> to the server. When connected, user is able to use any Linux DVB API
> compatible application on client side (like VDR, MeTV, MythTV, etc)
> without any need of code modification. As server can be used any
> Linux DVB API compatible device.

IMHO, this needs a Documentation file for the userspace API (kinda like 
tuntap.txt).

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
