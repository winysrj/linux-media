Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JvgkH-00072V-VB
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 00:43:53 +0200
Received: from [192.168.1.2] (02-065.155.popsite.net [66.217.132.65])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id m4CMhWr7024515
	for <linux-dvb@linuxtv.org>; Mon, 12 May 2008 18:43:33 -0400 (EDT)
From: Andy Walls <awalls@radix.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <200805121802.34413@orion.escape-edv.de>
References: <482560EB.2000306@gmail.com>
	<200805121516.48002@orion.escape-edv.de> <48284A6B.2020602@gmx.net>
	<200805121802.34413@orion.escape-edv.de>
Date: Mon, 12 May 2008 18:42:48 -0400
Message-Id: <1210632168.3194.5.camel@palomino.walls.org>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends
	tda10021	and	stv0297
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

On Mon, 2008-05-12 at 18:02 +0200, Oliver Endriss wrote:
> P. van Gaans wrote:
> > On 05/12/2008 03:16 PM, Oliver Endriss wrote:
> > > @all:
> > > 1. If nobody objects I will commit the patches.
> > > 2. Please check and fix the other frontend drivers to follow the spec.
> > 
> > Will the behaviour of femon change, and if so, in what way?
> 
> For a correct driver unc would not return to 0 (unless the counter
> wrapped).

And that is the critical part to support multiple opens on the device
and still return meaningful values.

If a 0 could happen under any other condition, the meaning of a 0 being
read would be ambiguous.  An application couldn't tell the difference
between:

a) an error occurred and the counter rolled over or
b) no error occurred and another caller simply cleared the count.

-Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
