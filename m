Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37379 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZDFLF4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 07:05:56 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>,
	isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20090406110430.400d4608@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl>
	 <20090405160519.629ee7d0@hyperion.delvare>
	 <1238960152.3337.84.camel@morgan.walls.org>
	 <20090406110430.400d4608@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 08:06:50 -0400
Message-Id: <1239019610.3157.8.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-04-06 at 11:04 +0200, Jean Delvare wrote:
> Hi Andy,


> I'm all for adding
> support for more boards, however I'd rather do this _after_ the i2c
> model conversion is done, so that we have a proper changelog entry
> saying that we added support for the PVR-150, and that it gets proper
> testing. Hiding support addition in a larger patch would probably do
> as much harm as good.


Makes sens to me.  Especially when I just simply, blindly added 0x71 in
my initial testing, I got a kernel Oops.

Regards,
Andy

