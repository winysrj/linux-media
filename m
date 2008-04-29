Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JqyVZ-0000S2-93
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 00:41:12 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Wed, 30 Apr 2008 00:40:13 +0200
References: <2d842fa80804282201h5665c596q4048d1f58fdaab5f@mail.gmail.com>
	<1209499089.3456.34.camel@pc10.localdom.local>
	<2d842fa80804291436t4464065bycb5b8d3b6b8dc19f@mail.gmail.com>
In-Reply-To: <2d842fa80804291436t4464065bycb5b8d3b6b8dc19f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804300040.13985@orion.escape-edv.de>
Subject: Re: [linux-dvb] saa7146_vv.ko and dvb-ttpci.ko undefined with
	kernel 2.6.23.17
Reply-To: linux-dvb@linuxtv.org
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

Stone wrote:
> Thanks for the confirmation.  Would you happen to know which file to edit so
> that I can add such missing dependencies (ie; videobuf-dma-sg)?  It seems
> like it should be a one line fix.  I would build "all" but my machine is so
> slow, it really drags on.  There must be an easier way.

You don't have to compile everything. Just select dpc7146 under
'Video capture adapters', and it will compile again.

The dependencies will be fixed asap.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
