Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JVyRZ-0000Tq-9C
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 01:22:13 +0100
Message-ID: <47CB44A8.5060103@gmail.com>
Date: Mon, 03 Mar 2008 04:22:00 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Florian Lohoff <flo@rfc822.org>
References: <20080301161419.GB12800@paradigm.rfc822.org>
	<47CB2D95.6040602@gmail.com>
	<20080302233653.GA3067@paradigm.rfc822.org>
In-Reply-To: <20080302233653.GA3067@paradigm.rfc822.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
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

Florian Lohoff wrote:
> Hi,
> 
> This is 
> why my application, which did not issue a GET_INFO but rather set the
> delivery system in the dvbfeparam, failed. The delivery in the

..

> 
> - A GET or READ call should never ever alter state - otherwise it should be named
>   different. Its the same with read/write, peek/poke, load/store set/get.
>   Just because i ask about informations concerning the DVB-S frontend does
>   not mean that i will not start DVB-S2 or DSS.

This won't work. params will contain data only after you have 
successfully issued
SET_PARAMS not before. For SET_PARAMS to work, you need the delivery system
cached for the operation.

Do you see the same bug with szap too ? 
(http://abraham.manu.googlepages.com/szap.c)


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
