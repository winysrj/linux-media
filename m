Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1KVlvy-000393-J3
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 13:33:03 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Wed, 20 Aug 2008 13:32:55 +0200
References: <48ABF856.504@ost-linux.co.uk>
In-Reply-To: <48ABF856.504@ost-linux.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808201332.55834.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] Max DVB frontends
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

On Wednesday 20 August 2008 12:56:22 John Brown wrote:
> Is the a maximum number of dvb frontends.  As I can't get more the 8
> to register, all the devices work separately but after the 8th device
> registers calls to dvb_register_adapter() fail with errno -23.  If
> there is a set limit is there away to change it a run time, or is it
> a matter of altering some defines and rebuilding the kernel.

Source code change and recompile. The maximal number is defined as 
MAX_DVB_ADAPTERS in drivers/media/dvb/dvb-core/dvbdev.h.

HTH Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
