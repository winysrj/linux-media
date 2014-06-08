Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sg1lp0093.outbound.protection.outlook.com ([207.46.51.93]:41815
	"EHLO APAC01-SG1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaFHKoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 06:44:11 -0400
From: James Harper <james@ejbdigital.com.au>
To: =?iso-8859-1?Q?Ren=E9?= <poisson.rene@neuf.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: fusion hdtv dual express 2 (working, kind of)
Date: Sun, 8 Jun 2014 10:44:06 +0000
Message-ID: <a176ddd0380748c8937ae09bc63a7ed4@SIXPR04MB304.apcprd04.prod.outlook.com>
References: <c01bd13c8e7241339365ecd0785fc3c4@SIXPR04MB304.apcprd04.prod.outlook.com>
 <2406CE434D5342D8B36CACED1EB791F6@ci5fish>
 <c48e37ce86984e7a9e0822c9745aaa9e@SIXPR04MB304.apcprd04.prod.outlook.com>
 <6996ac578102422aae71af927d820e79@SIXPR04MB304.apcprd04.prod.outlook.com>
In-Reply-To: <6996ac578102422aae71af927d820e79@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Turns out if I turn off xen (machine is running as a dom0 (xen host, not inside a vm)), it all works perfectly.

I assume this issue isn't limited to my new dual express 2 card?? Any suggestions where to look?

James

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of James Harper
> Sent: Sunday, 8 June 2014 8:36 PM
> To: René; linux-media@vger.kernel.org
> Subject: RE: fusion hdtv dual express 2 (working, kind of)
> 
> One thing I just noticed, it's always the same pages in each buffer that is 'lost'
> (in "find_next_packet"). If I printk some details, the 'lost' parts are always
> some multiple of 4k in size (with allowance for 188 byte packet).
> 
> printk("find_next_packet() lost %p %d-%d (%d)\n", buf, start, pos, lost);
> 
> and then formatting the output through sort -u to eliminate duplicates
> produces output like:
> 
> ffffc90002966000 0-24064 (24064)
> ffffc90002987000 0-4136 (4136)
> ffffc90002990000 0-4136 (4136)
> ffffc90002990000 20492-24064 (3572)
> ffffc90002999000 0-4136 (4136)
> ffffc900029a2000 0-4136 (4136)
> ffffc900029ab000 12408-20492 (8084)
> ffffc900029b4000 4136-12408 (8272)
> ffffc900029bd000 12408-20492 (8084)
> ffffc900029c6000 0-4136 (4136)
> ffffc900029c6000 20492-24064 (3572)
> ffffc900029cf000 20492-24064 (3572)
> ffffc900029d8000 16544-20492 (3948)
> ffffc900029d8000 4136-12408 (8272)
> ffffc900029ea000 0-4136 (4136)
> 
> so taking ffffc900029d8000 as an example, the second and third pages have
> no data in them, and neither does the fifth page. This happens every time
> ffffc900029d8000 is accessed.
> 
> So I'm guessing that the sg list hasn't been programmed correctly or
> something... does that sound right? I guess I'll print out the pfn's to see if
> there is a pattern there next...
> 
> James
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
