Return-path: <linux-media-owner@vger.kernel.org>
Received: from hosted-by.2is.nl ([62.221.193.103]:48533 "EHLO jcz.nl"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZAWHq0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 02:46:26 -0500
Message-ID: <4979743E.2000502@jcz.nl>
Date: Fri, 23 Jan 2009 08:39:42 +0100
From: Jaap Crezee <jaap@jcz.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] device file ordering w/multiple cards
References: <alpine.LFD.2.00.0901221641300.8219@tupari.net> <4978FFC1.4010301@ziv.id.au>
In-Reply-To: <4978FFC1.4010301@ziv.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Zivkovic wrote:
> Joseph Shraibman wrote:
> I have two dvb cards in my system.  Is there any way to change the order 
> of the device files?

It might also be possible to use udev for this kind of ordering. Maybe just like the persistent-[net|storage] scripts in
/etc/udev/rules.d

Regards,

Jaap Crezee
