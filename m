Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:49260 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZE1Gqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 02:46:40 -0400
Message-ID: <4A1E32CE.9090203@freemail.hu>
Date: Thu, 28 May 2009 08:44:30 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: [RFC,PATCH] VIDIOC_G_EXT_CTRLS does not handle NULL pointer correctly
References: <200905251317.02633.laurent.pinchart@skynet.be> <Pine.LNX.4.58.0905251213500.32713@shell2.speakeasy.net> <200905271727.01409.laurent.pinchart@skynet.be>
In-Reply-To: <200905271727.01409.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart worte:
> Could a very large number of control requests be used as a DoS attack vector ? 
> A userspace application could kmalloc large amounts of memory without any 
> restriction. Memory would be reclaimed eventually, but after performing a 
> large number of USB requests, which could take quite a long time.

A DoS attacker could open the /dev/video0 several times even from one single
process (from different threads) and could kmalloc() as much memory as the
attacker wants. Maybe even one file descriptor would be enough using it from
different threads. This could force the system to swap out pages to get the
necessary memory.

I don't know if more than one instance of the VIDIOC_G_EXT_CTRLS requests can
actively keep memory allocated or only one can run at a time forcing the other
requests to sleep until the previous one hadn't been finished. This is also
true for VIDIOC_S_EXT_CTRLS and VIDIOC_TRY_EXT_CTRLS.

Regards,

	Márton Németh
