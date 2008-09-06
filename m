Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Kc6BM-0003uZ-SI
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 00:23:06 +0200
Message-ID: <48C302B6.5080503@gmail.com>
Date: Sun, 07 Sep 2008 02:22:46 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Simon Baxter <linuxtv@nzbaxters.com>
References: <2ef701c91059$12152840$7501010a@ad.sytec.com>
In-Reply-To: <2ef701c91059$12152840$7501010a@ad.sytec.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT C-1501 patch and multiproto not compile
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

Simon Baxter wrote:
> Hi
> 
> I can't get the attached patch to compile with the current or with 7213
> of the multi-proto branch.  I get the following errors.
> 
> Also, is the support for this TechnoTrend variant card going to be
> included as standard?
> 
> [root@freddy multiproto]# make

> 
> Can anyone help?
>

I have just updated the multiproto tree. Please try a fresh clone.
Also have applied the patch from Anssi Hannula:

"add support for using multiproto drivers with old api"

thereby allowing the "multistandard" drivers to use the old applications
such as szap, scan, (applications supported by the old API) without any
modifications for the "QPSK" (DVB-S) mode of operation alone.

NOTE: The push is going on, it will be a short while for the repository
to be populated.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
