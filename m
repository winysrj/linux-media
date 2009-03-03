Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout.assembly.state.ny.us ([204.97.104.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <m+linuxdvb@mattyo.net>) id 1LeWAb-0007ox-Dt
	for linux-dvb@linuxtv.org; Tue, 03 Mar 2009 16:04:34 +0100
Received: from mail1.nysa.us (nysa-bh1.assembly.state.ny.us [204.97.104.30])
	by mailout.assembly.state.ny.us (8.14.1/8.14.1) with ESMTP id
	n23F3uAM031878
	for <linux-dvb@linuxtv.org>; Tue, 3 Mar 2009 10:03:57 -0500
Received: from [10.2.10.171] ([10.2.10.171])
	by mail1.nysa.us (8.14.2/8.14.2) with ESMTP id n23F3uIU016513
	for <linux-dvb@linuxtv.org>; Tue, 3 Mar 2009 10:03:56 -0500
Message-ID: <49AD46DC.4080701@mattyo.net>
Date: Tue, 03 Mar 2009 10:03:56 -0500
From: Matt Garretson <m+linuxdvb@mattyo.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1236078001.32084.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1236078001.32084.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] WinTV HVR-1800 analog Satus
Reply-To: linux-media@vger.kernel.org
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

Steven Toth wrote:
> Dustin Coates wrote:
> > Any update on the status of analouge for this card? I really would  
> 
> Last I checked it worked fine for me.



Does anyone have an HVR-1800 (digital or analog) coexisting with a 
PVR-250?  Mythtv-setup crashes for me when scanning ATSC/QAM channels
on the HVR-1800.  Admittedly, I haven't tried to debug it beyond that.
But I'm just wondering if these IVTV and DVB devices can coexist at
all.

Also, does the 2.6.27 kernel have recent enough v4l/dvb stuff for the 
HVR-1800 merged in, or should I still be pulling from the linuxtv 
repository?

Thanks...
-Matt

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
