Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3787 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934429Ab3CHQfv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 11:35:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Sri Deevi" <Srinivasa.Deevi@conexant.com>
Subject: Re: Firmware for cx23885 in linux-firmware.git is broken
Date: Fri, 8 Mar 2013 17:35:13 +0100
Cc: "Andy Walls" <awalls@md.metrocast.net>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Ben Hutchings" <ben@decadent.org.uk>,
	"Joseph Yasi" <joe.yasi@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"David Woodhouse" <dwmw2@infradead.org>,
	"Michael Krufky" <mkrufky@linuxtv.org>
References: <CADzA9okNTohmDwxbQNri4y8Gb-=BksugMSiCNaGMzFQXDyLu7g@mail.gmail.com> <1361741900.1943.88.camel@palomino.walls.org> <a7ef1025-2217-49b7-bf98-1cc37a06f958@cnxthub1.bbnet.ad>
In-Reply-To: <a7ef1025-2217-49b7-bf98-1cc37a06f958@cnxthub1.bbnet.ad>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303081735.14031.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue February 26 2013 19:57:45 Sri Deevi wrote:
> Mauro/Andy/Hans,
> 
> I got the latest version of firmware for encoder Cx23416, build release version 120. Is it possible for you guys to verify with your hardware and let me know. If it works, then we can set this as start point or base for any next release. I believe it should work on all versions of encoders series we have.

I gave it a quick spin on my pvr350 and it looked OK, but if you have some
background information regarding what was changed since the previous version,
then I can do a few more specific tests.

Regards,

	Hans
