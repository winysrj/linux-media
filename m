Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:49301 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3GQIo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 04:44:29 -0400
Date: Wed, 17 Jul 2013 05:44:29 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Cc: linux-media@vger.kernel.org
Subject: Re: Possible problem with stk1160 driver
Message-ID: <20130717084428.GA2334@localhost>
References: <20130716220418.GC10973@deadlock.dhs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130716220418.GC10973@deadlock.dhs.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergey,

On Wed, Jul 17, 2013 at 12:04:18AM +0200, Sergey 'Jin' Bostandzhyan wrote:
> 
> It generally works fine, I can, for example, open the video device using VLC,
> select one of the inputs and get the picture.
> 
> However, programs like motion or zoneminder fail, I am not quite sure if it
> is something that they might be doing or if it is a problem in the driver.
> 
> Basically, for both of the above, the problem is that VIDIOC_S_INPUT fails
> with EBUSY.
> 

I've just sent a patch to fix this issue.

Could you try it and let me know if it solves your issue?

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
