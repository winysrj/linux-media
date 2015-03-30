Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:34076 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbbC3Td5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 15:33:57 -0400
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Subject: Re: mceusb: sysfs: cannot create duplicate filename '/class/rc/rc0'  (race condition between multiple =?UTF-8?Q?RC=5FCORE=20devices=29?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 30 Mar 2015 21:33:55 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	m.chehab@samsung.com, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	Tomas Melin <tomas.melin@iki.fi>
In-Reply-To: <20150330173031.1fb46443@mir>
References: <201412181916.18051.s.L-H@gmx.de>
 <201412302211.40801.s.L-H@gmx.de> <20150330173031.1fb46443@mir>
Message-ID: <61aca9029bf06b2a3f322018aee00dda@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-03-30 17:30, Stefan Lippers-Hollmann wrote:
> Hi
> 
> This is a follow-up for:
> 	http://lkml.kernel.org/r/<201412181916.18051.s.L-H@gmx.de>
> 	http://lkml.kernel.org/r/<201412302211.40801.s.L-H@gmx.de>
> 

I can't swear that it's the case but I'm guessing this might be fixed by 
the patches I posted earlier (in particular the one that converted 
rc-core to use the IDA infrastructure for keeping track of registered 
minor device numbers).

//D


