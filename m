Return-path: <linux-media-owner@vger.kernel.org>
Received: from gate2.ipvision.dk ([94.127.49.3]:54406 "EHLO gate2.ipvision.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760554Ab2JaT6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 15:58:12 -0400
From: Benny Amorsen <benny+usenet@amorsen.dk>
To: Frank =?utf-8?Q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<m3vcdr1ku9.fsf@ursa.amorsen.dk> <50911079.7010404@googlemail.com>
Date: Wed, 31 Oct 2012 20:58:07 +0100
In-Reply-To: <50911079.7010404@googlemail.com> ("Frank =?utf-8?Q?Sch=C3=A4?=
 =?utf-8?Q?fer=22's?= message of
	"Wed, 31 Oct 2012 13:50:17 +0200")
Message-ID: <m3pq3ywh0w.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Frank Schäfer <fschaefer.oss@googlemail.com> writes:

> It seems like your device has no bulk endpoint for DVB.
> What does lsusb say ?

lsusb mentions 4 different end points, all isochronous. So out of luck
there. I did not know I could use lsusb to find this out.

> The module parameter is called prefer_bulk, but what it actually does is
> "force bulk" (which doesn't make much sense when the device has no bulk
> endpoints).
> I will fix this in v2 of the patch series.

Well, I was hoping to get "force_bulk", so that part is not a problem
for me.

> Am 31.10.2012 03:39, schrieb Benny Amorsen:

>> It works great with isochronous transfers on my PC and the Fedora
>> kernel, but the Raspberry USB host blows up when trying to do
>> isochronous mode.
>
> Is this a regression caused by patches or a general issue with the
> Raspberry board ?

It is a general issue with the Raspberry USB host controller or driver.
Bulk transfers work, isochronous transfers have problems. I was hoping I
could somehow convince the Nanostick to use bulk transfers instead of
isochronous transfers. Since that seems to require a firmware change, I
will have to give up on it.


/Benny

