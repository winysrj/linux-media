Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+e77cda1470bd12f604e2+1669+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JbpOR-0005oI-06
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 04:55:11 +0100
Date: Tue, 18 Mar 2008 23:54:05 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Albert Comerma <albert.comerma@gmail.com>
In-Reply-To: <ea4209750803181509s7efe3ceavfe17f1e7590b3405@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803182350500.24094@bombadil.infradead.org>
References: <ea4209750803181311y17782b40ib95f900b99bf6673@mail.gmail.com>
	<20080318182338.19dd7ff5@gaivota>
	<ea4209750803181509s7efe3ceavfe17f1e7590b3405@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PATCH Pinnacle 320cx Terratec Cinergy HT USB XE
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tue, 18 Mar 2008, Albert Comerma wrote:

> Ok I will redo the patch, right now I don't have the card to check without
> the reset command, but I will check the weekend. Hans also should check with
> the Cinergy card...
> Just one comment, doing a make checkpatch on dib0700_devices.c does not
> detect a lot of this coding conventions that are not satisfied on the MT226x
> code section... Shall I correct all I found? or better just the code I
> inserted and then the rest in an other patch?

Please fix just the lines you've added or changed.

A fix on other parts may harm any other pending patches for dib0700. We 
generally avoid such patches.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
