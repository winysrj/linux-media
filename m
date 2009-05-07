Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail05.svc.cra.dublin.eircom.net ([159.134.118.21]:47243 "HELO
	mail05.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752350AbZEGNM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 09:12:27 -0400
Subject: Re: CX24123 no FE_HAS_LOCK/tuning failed.
From: John Donoghue <jdonog01@eircom.net>
To: biteme@sclnz.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4A02C426.2030703@wowway.com>
References: <4A02C426.2030703@wowway.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 14:12:26 +0100
Message-Id: <1241701946.6790.38.camel@john-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rex,

The Hauppauge WinTV Nova-S-Plus has had problems with hi-band
transponders since the 2.6.20 kernel or thereabouts.  The Optus D1
transponders all seem to be hi-band.  See the thread at:
http://bugzilla.kernel.org/show_bug.cgi?id=9476 where I outlined a
fix which works OK for this card, but is not robust enough for
general use.

In my last post to that thread I make a reference to the isl6421.h
file, but it should be to the isl6421.c file.  I was confused as that
file identifies itself as isl6421.h in line 2.  I made no change to
isl6421.h.

Regards,
John


