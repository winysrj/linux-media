Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49664 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab0BCOaA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 09:30:00 -0500
Date: Wed, 3 Feb 2010 15:31:26 +0100
From: Janne Grunau <j@jannau.net>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] hdpvr-video: cleanup signedness
Message-ID: <20100203143126.GE7946@aniel.lan>
References: <4B5AFD42.6080001@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B5AFD42.6080001@freemail.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 23, 2010 at 02:44:34PM +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The fifth parameter of usb_bulk_msg() is a pointer to signed
> (see <linux/usb.h>) so also call this function with pointer to signed.
> 
> This will remove the following sparse warning (see "make C=1"):
>  * warning: incorrect type in argument 5 (different signedness)
>        expected int *actual_length
>        got unsigned int *<noident>
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Thanks, I'll send a git pull request including the second patch for Mauro
later today.

cheers Janne
