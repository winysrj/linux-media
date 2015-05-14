Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35763 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933101AbbENRE6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 13:04:58 -0400
Date: Thu, 14 May 2015 14:04:53 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: [RFC PATCH 6/6] [media] rc: teach lirc how to send scancodes
Message-ID: <20150514140453.10e67e14@recife.lan>
In-Reply-To: <985a9b11e5e02eb43e16d27db23086528434be24.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
	<985a9b11e5e02eb43e16d27db23086528434be24.1426801061.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Mar 2015 21:50:17 +0000
Sean Young <sean@mess.org> escreveu:

> The send mode has to be switched to LIRC_MODE_SCANCODE and then you can
> send one scancode with a write. The encoding is the same as for receiving
> scancodes.
> 
> FIXME: Currently only the nec encoder can encode IR.
> FIXME: The "decoders" should be renamed (codec?)

The FIXMEs should of course be addressed to merge this one ;)

The patch's idea makes sense to me, but I'll let to review it on a next
spin of this patch series.
