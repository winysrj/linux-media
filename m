Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:41444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588Ab0LMNbm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:31:42 -0500
Message-ID: <4D062037.7040303@redhat.com>
Date: Mon, 13 Dec 2010 11:31:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/6] gspca sonixj better handling of reg 01 and 17
References: <20101213140229.6379b78d@tele>
In-Reply-To: <20101213140229.6379b78d@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-12-2010 11:02, Jean-Francois Moine escreveu:
> Here is an other way to fix the inv powerdown bug.

Didn't test yet, but it seems that this series will properly address the issue.
> 
> These patches are not tested yet.
> 
> Jean-François Moine (6):
>       gspca - sonixj: Move bridge init to sd start
>       gspca - sonixj: Fix a bad probe exchange
>       gspca - sonixj: Add a flag in the driver_info table
>       gspca - sonixj: Set the flag for some devices
>       gspca - sonixj: Add the bit definitions of the bridge reg 0x01 and 0x17
>       gspca - sonixj: Better handling of the bridge registers 0x01 and 0x17
> 
>  drivers/media/video/gspca/sonixj.c |  410 ++++++++++++++++--------------------
>  1 files changed, 182 insertions(+), 228 deletions(-)
> 

Cheers,
Mauro
