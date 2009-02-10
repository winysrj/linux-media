Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:46640 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZBJSZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 13:25:28 -0500
Date: Tue, 10 Feb 2009 10:25:26 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Eduard Huguet <eduardhc@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: cx8802.ko module not being built with current HG tree
In-Reply-To: <617be8890902100349r39c49edfr4c3373669d698b72@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0902101018260.24268@shell2.speakeasy.net>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
 <617be8890902050759x74c08498o355be1d34d7735fe@mail.gmail.com>
 <20090210093753.69b21572@pedra.chehab.org> <617be8890902100349r39c49edfr4c3373669d698b72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Feb 2009, Eduard Huguet wrote:
>     I don't have yet the buggy config, but the steps I was following
> when I encounter the problem were the following:
>         · hg clone http://linuxtv.org/hg/v4l-dvb
>         · cd v4l-dvb
>         · make menuconfig

This is what I did too.  Just use the menuconfig or xconfig targets.  Maybe
the kernel kconfig behavior has changed?
