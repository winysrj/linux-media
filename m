Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:28470 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2EWJWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:22:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Belisko Marek <marek.belisko@gmail.com>
Subject: Re: FM si4712 driver
Date: Wed, 23 May 2012 11:21:43 +0200
Cc: linux-media@vger.kernel.org
References: <CAAfyv36ejCC1EZH3VyH4B+8UcBAvdYgpWc3=o6K6Bv5HU4V=mg@mail.gmail.com>
In-Reply-To: <CAAfyv36ejCC1EZH3VyH4B+8UcBAvdYgpWc3=o6K6Bv5HU4V=mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205231121.43359.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 23 May 2012 11:09:04 Belisko Marek wrote:
> Hi,
> 
> I'm planning to start writing driver for si4712 (for GTA04).
> Anybody doing same thing to avoid double work?

There is a driver for the si4713 already. Is the si4712 very different from
the si4713? If it is very similar, then I would suggest that you adapt the
si4713 driver to also support the si4712.

Regards,

	Hans
