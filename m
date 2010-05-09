Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:52604 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0EIT31 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 May 2010 15:29:27 -0400
Subject: Re: stv090x vs stv0900
From: Abylai Ospan <aospan@netup.ru>
To: Pascal Terjan <pterjan@mandriva.com>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	"Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org
In-Reply-To: <1273135577.16031.11.camel@plop>
References: <1273135577.16031.11.camel@plop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 May 2010 23:06:19 +0400
Message-ID: <1273431979.4779.786.camel@alkaloid.netup.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thu, 2010-05-06 at 10:46 +0200, Pascal Terjan wrote:
> Also, are they both maintained ? I wrote a patch to add get_frontend to
> stv090x but stv0900 also does not have it and I don't know which one
> should get new code.

I have added get_frontend to stv0900 two months ago -
http://linuxtv.org/hg/v4l-dvb/rev/a3e28fbefdc3

I'm trying to describe my point of view about two drivers for stv6110
+stv0900. 

History:
I have anounced our card on November 2008 -
http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030439.html
As you can see I have mentioned that we developing code and will be
publish it under GPL. All people in ML received this message. This
should be prevent of duplicate work.
Also we have obtained permission (signed letter) from STM to publish
resulting code under GPL. We have send pull request at Feb 2009 -
http://www.mail-archive.com/linux-media@vger.kernel.org/msg02180.html

(stv090x commit requested later - in May 2009 -
http://www.mail-archive.com/linux-media@vger.kernel.org/msg04978.html ).


Solution:
Ideally two drivers should be combined into one. stv0900 driver can be
used as starting point. We (NetUP Inc.) can initiaite this job. But we
need approval from Manu and all community who using stv090x. Manu what
do you think about this ? 
This is not trivial because some "features" may be broken when combining
this two code.

-- 
Abylai Ospan <aospan@netup.ru>
NetUP Inc.

P.S.
>From our side we have strong experience in STV6110+STV0900 IC's. Our
engeneers designed "NetUP Dual DVB-S2 CI" card  from "scratch". We know
many nuances about this IC's. For example, we have tested 16APSK/32APSK
-
http://linuxtv.org/wiki/index.php/STMicroelectronics_STV0900A_16APSK_32APSK

Also we developing new version of our "NetUP Dual DVB-S2 CI" based on
FPGA (like our Dual DVB-T/C CI card -
http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF ). This new
version of card can proceed high bitrates from STV0900 (120Mbps and
higher ). Also this card can receive raw frames from STV0900 ( not only
TS ) for extra functionality ( GSE ).

