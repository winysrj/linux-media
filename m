Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab0BUUBO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 15:01:14 -0500
Message-ID: <4B819102.90809@redhat.com>
Date: Sun, 21 Feb 2010 17:01:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Catimimi <catimimi@orange.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/master] V4L/DVB: em28xx : Terratec Cinergy Hybrid
 T USB XS FR is working
References: <E1NiJbR-0002DD-UB@www.linuxtv.org> <4B80EBEB.4010005@orange.fr>
In-Reply-To: <4B80EBEB.4010005@orange.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Catimimi wrote:
i,
> 
> This patch works well on a 32bits kernel but not on a 64 bits one.
> (openSUSE 11.2)
> I'm working on that problem.

64bits kernel with 64 bit usespace or are you using a 32bits application with a
64 bits kernel? 

Cheers,
Mauro
