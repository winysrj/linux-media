Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:46572 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab1GORSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 13:18:33 -0400
From: remzouille <remzouille@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: patch for Asus My Cinema PS3-100 (1043:48cd)
Date: Fri, 15 Jul 2011 19:18:24 +0200
References: <201107141128.23344.remzouille@free.fr> <4E1F1E5F.2040302@redhat.com>
In-Reply-To: <4E1F1E5F.2040302@redhat.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107151918.24938.remzouille@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 14 juillet 2011 18:50:39, vous avez écrit :
> Em 14-07-2011 06:28, remzouille escreveu:
> > Hi all,
> > 
> > This is the patch against kernel 2.6.32 I used to get to work my TV card
> > Asus My Cinema PS3-100 (1043:48cd).
> > 
> > More information on this card can be found on this page :
> > 
> > http://techblog.hollants.com/2009/09/asus-mycinema-ps3-100-3-in-1-tv-card
> > /
> > 
> > This card seems to be a clone of the Asus Tiger 3in1, numbered 147 in the
> > SAA7134 module, so I gave it the temporary number of 1470.
> > 
> > It has in addition a remote controller that works fine with the
> > ir_codes_asus_pc39_table. I haven't finished the work on all keys but the
> > most usefull ones are working.
> 
> Please finish the keytable mapping and re-send it with your Signed-off-By.
> 

Ok, I'll do that when I am back at home in a few days.
As I said, the remote is already quite fully functional.

> > DVB-T and remote have been tested and work fine.
> > DVB-S, FM and Composite input haven't been tested.
> > 
> > Hope that will help some of you.
> 
> Thanks!
> Mauro

You're welcome !

Rémi
