Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:46503 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798Ab3LEMWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 07:22:42 -0500
Date: Thu, 5 Dec 2013 09:22:40 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Andrea Venturi <a.venturi@avalpa.com>
Cc: linux-media@vger.kernel.org
Subject: Re: advice on Easycap dongles and VBI interface..
Message-ID: <20131205122239.GB2345@localhost>
References: <52A058EF.9000701@avalpa.com>
 <52A0693C.7060704@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52A0693C.7060704@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrea and Hans,

On Thu, Dec 05, 2013 at 12:53:32PM +0100, Hans Verkuil wrote:
> 
> > - finally which approach do you suggest for supporting this ancient
> > feature, if feasibiliy tests are ok: - a libusb quick hack? - an
> > implementation of the bindings between user level /dev/vbi and
> > underlying SAA711x routines?
> 
> The problem is that I don't believe we have any stk1160 documentation.

I do have the stk1160 chip datasheet. However, it's not publicly
available and I'm not sure I should disclose it (although syntek never
advise me against it). In additio, the datasheet is not very verbose
and the information is scarce and often incomplete.

> And I wonder if the device can support VBI at all.
> 

Apparently it does: at least there's a flag to "enable" VBI mode.

> You are better off choosing devices that already have VBI support: the
> em28xx supports it, so do bt8xx, cx18 and ivtv.
> 

I agree with this. I don't have any VBI source so there's no way I can
work on this (not to mention it's not something lots of users need).
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
