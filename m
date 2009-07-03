Return-path: <linux-media-owner@vger.kernel.org>
Received: from acoma.photonsoftware.net ([65.254.60.10]:40810 "EHLO
	acoma.photonsoftware.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZGCKjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 06:39:33 -0400
Received: from localhost ([127.0.0.1] helo=[127.0.0.100])
	by acoma.photonsoftware.net with esmtpa (Exim 4.69)
	(envelope-from <ldone@hubstar.net>)
	id 1MMgB2-0006fX-3q
	for linux-media@vger.kernel.org; Fri, 03 Jul 2009 11:39:32 +0100
Message-ID: <4A4DDFE7.2000000@hubstar.net>
Date: Fri, 03 Jul 2009 11:39:35 +0100
From: "ldone@hubstar.net" <ldone@hubstar.net>
Reply-To: "l d one"@hubstar.net
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: cx23885 HVR-1700 broken in v4l drivers vs standard kernel
References: <4A40BEFA.1030404@redhat.com> <20090702142301.718d26e7@pedra.chehab.org> <4A4DCA54.2070401@redhat.com>
In-Reply-To: <4A4DCA54.2070401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

if I use stock kernel (Suse)  2.6.27.23-0.1 the card works, scans and
plays DVB-T channels.
if I use the latest v4l drivers the card is recognised, and picked up,
tunes a channel, but cannot find any DVB-T channels.

I'm afraid I'm not sure what to look for

Thanks

