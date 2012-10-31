Return-path: <linux-media-owner@vger.kernel.org>
Received: from gate2.ipvision.dk ([94.127.49.3]:52599 "EHLO gate2.ipvision.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab2JaUYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 16:24:48 -0400
From: Benny Amorsen <benny+usenet@amorsen.dk>
To: Frank =?utf-8?Q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<m3vcdr1ku9.fsf@ursa.amorsen.dk>
	<CALF0-+WHPbdg6eVS8cN00vfcN_HJLYfkWYN9kpRfDBAyOeFV0g@mail.gmail.com>
	<50911395.8090805@googlemail.com>
Date: Wed, 31 Oct 2012 21:24:45 +0100
In-Reply-To: <50911395.8090805@googlemail.com> ("Frank =?utf-8?Q?Sch=C3=A4?=
 =?utf-8?Q?fer=22's?= message of
	"Wed, 31 Oct 2012 14:03:33 +0200")
Message-ID: <m3hapawfsi.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frank Schäfer <fschaefer.oss@googlemail.com> writes:

> For DVB, the em28xx always selects the alternate setting with the
> largest wMaxPacketSize.
> There is a module parameter 'alt' to select it manually for experiments,
> but the current code unfortunately applies it for analog capturing only. :(

What is the meaning of "alternate setting" here? Would I gain anything
if the driver was modified to apply alternate setting for DVB as well?


/Benny

