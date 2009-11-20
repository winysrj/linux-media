Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:62452 "EHLO
	studserv5d.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753595AbZKTOF3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 09:05:29 -0500
Message-ID: <4B06A22D.4090404@stud.uni-hannover.de>
Date: Fri, 20 Nov 2009 15:05:33 +0100
From: Soeren Moch <Soeren.Moch@stud.uni-hannover.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: SV: [linux-dvb] NOVA-TD exeriences?
References: <4AEF5FE5.2000607@stud.uni-hannover.de> <4AF162BC.4010700@stud.uni-hannover.de> <4B0694F7.7070604@stud.uni-hannover.de>
In-Reply-To: <4B0694F7.7070604@stud.uni-hannover.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 > >  > Hi again. Just got my two new NOVA-TD's and at a first glance they
 > > seemed to
 > >  > perform well. Closer inspections however revealed that I see exactly
 > > the same
 > >  > issues as Soeren. Watching live TV with VDR on one adaptor while
 > > constantly
 > >  > retuning the other one using:
 > >  > while true;do tzap -x svt1;done
 > >  > gives a short glitch in the VDR stream on almost every tzap. Another
 > > 100EUR down
 > >  > the drain. I'll probably buy four NOVA-T's instead just like I
 > > planned to at
 > >  > first.
 > >  >
 > >  > /Magnus H
 > >
 > > Slowly, slowly. Magnus, you want to support dibcom with another 
100EUR for
 > > there poor performance in fixing the firmware?
 > > Please test my patches, the nova-td is running fine with these patches,
 > > at least for me.
 > >
 > > Patrick, any progress here? Will dibcom fix the firmware, or will you
 > > integrate the
 > > patches? Or what can I do to go on?
 > >
 > > Regards,
 > > Soeren
 > >
 > >
 >
 > Thanks Soeren, maybe I jumped to the wrong conclusions here. I actually
 > thought this came down to bad hardware design instead of a 
driver/firmware
 > issue. Unfortunately your patches made no difference here but I won't 
give
 > up that easily. If they made your problems disapperar there should be 
hope
 > for me too and I'll be glad to help in the development. I can live 
with the
 > glitches in the mean time if there's hope for improvement since I mostly
 > watch DVB-S these days. I'm running the stock Ubuntu Karmic 2.6.31 kernel
 > and standard linuxtv drivers from hg. I also have four TT S2-1600 
cards in
 > there.
 > /Magnus

Magnus, can you send the USB-IDs of your nova-td-sticks, please?
Since I activated the workaround only for stk7700d_dib7000p_mt2266,
there might be another funtion to fix your sticks.

Soeren


