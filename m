Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1705 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761490AbaGSLcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jul 2014 07:32:39 -0400
Message-ID: <53CA574C.30604@xs4all.nl>
Date: Sat, 19 Jul 2014 13:32:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Moses <moses@neonixie.com>, linux-media@vger.kernel.org
Subject: Re: modern software with analog (BT787) overlay support? / XAWTV
 replacement ?
References: <S1751671AbaGRXys/20140718235448Z+394@vger.kernel.org> <53C9B6FD.8010504@neonixie.com>
In-Reply-To: <53C9B6FD.8010504@neonixie.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Moses,

On 07/19/2014 02:08 AM, Moses wrote:
> Hello,
> 
> I need a replacement for an aging box that is using xawtv to display 
> CCTV cameras (from a BT878 card) on a X windows display. Xawtv is 
> capable of hardware overlay directly onto the X display with almost no 
> CPU usage and pretty much real time, it has worked great for years.. but 
> now the box needs modern hardware and software. I have attempted to 
> compile xawtv using more modern versions of linux.. but I think xawtv is 
> just too old to mess with at this point.. so the question is..
> 
> Anyone know of any other suitable software that will allow analog video 
> overlay from BT878 chips?

The problem is not xawtv, the problem is that modern gpus no longer support
overlays. On the other hand, modern gpus are much faster and should have
no problem handling the video bttv delivers.

Xawtv still works fine for modern hardware, it just won't be using the
overlay capability anymore.

Regards,

	Hans

