Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab1GNQuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 12:50:44 -0400
Message-ID: <4E1F1E5F.2040302@redhat.com>
Date: Thu, 14 Jul 2011 13:50:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: remzouille <remzouille@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: patch for Asus My Cinema PS3-100 (1043:48cd)
References: <201107141128.23344.remzouille@free.fr>
In-Reply-To: <201107141128.23344.remzouille@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-07-2011 06:28, remzouille escreveu:
> Hi all,
> 
> This is the patch against kernel 2.6.32 I used to get to work my TV card Asus 
> My Cinema PS3-100 (1043:48cd).
> 
> More information on this card can be found on this page :
> 
> http://techblog.hollants.com/2009/09/asus-mycinema-ps3-100-3-in-1-tv-card/
> 
> This card seems to be a clone of the Asus Tiger 3in1, numbered 147 in the
> SAA7134 module, so I gave it the temporary number of 1470.
> 
> It has in addition a remote controller that works fine with the
> ir_codes_asus_pc39_table. I haven't finished the work on all keys but the
> most usefull ones are working.

Please finish the keytable mapping and re-send it with your Signed-off-By.

> 
> DVB-T and remote have been tested and work fine.
> DVB-S, FM and Composite input haven't been tested.
> 
> Hope that will help some of you.

Thanks!
Mauro
