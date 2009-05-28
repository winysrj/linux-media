Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:51094 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575AbZE1Tpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 15:45:43 -0400
Subject: Re: [PATCH] Leadtek WinFast DTV-1800H support
From: hermann pitton <hermann-pitton@arcor.de>
To: Miroslav =?UTF-8?Q?=C5=A0ustek?= <sustmidown@centrum.cz>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090528T183711-833@post.gmane.org>
References: <200905102337.22307@centrum.cz> <200905102338.14151@centrum.cz>
	 <200905102339.24789@centrum.cz> <200905102339.14742@centrum.cz>
	 <loom.20090528T183711-833@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 May 2009 21:42:18 +0200
Message-Id: <1243539738.3769.21.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Miroslav,

Am Donnerstag, den 28.05.2009, 18:44 +0000 schrieb Miroslav Šustek:
> Any problem with this patch?
> I'm trying to get WinFast DTV-1800H support into repository for seven months.
> (see:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/1125/match=1800h
> )
> 

just saw this patch on another machine and it reminded me also on your
patch to select different frontends on multiple multi frontends card at
insmod, which can be quite useful and was tested by me.

They must pass the checks "patchwork" does, this includes to run "make
checkpatch" on them previously and then you will see them very soon in

http://patchwork.kernel.org/project/linux-media/list

They seem not to be there, also not with filters "any" set, and you
should have seen an automated commit message, if they should have made
it into v4l-dvb.

Please resend and check short time later, if they are at patchwork
linux-media.

Some sort of reject message would of course be fine on such and make
life easier, but does not happen yet.

Cheers,
Hermann






