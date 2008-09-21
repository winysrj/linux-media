Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KhOyS-0001eF-Py
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 15:27:41 +0200
Message-ID: <48D64BC4.2010503@gmail.com>
Date: Sun, 21 Sep 2008 17:27:32 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: n.wagenaar@xs4all.nl
References: <vmime.48d6486d.2764.1cf647ed6cec189b@shalafi.ath.cx>
In-Reply-To: <vmime.48d6486d.2764.1cf647ed6cec189b@shalafi.ath.cx>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Full Mantis pull with TerraTec Cinergy S2 PCI HD
 hangs system on boot
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

Niels Wagenaar wrote:
> Hello All,
> 
> Currently I have some more information. When using the repo from http://jusst.de/hg/mantis.old and compile it (I didn't change the ID) it works. It boots Linux, it's detected and the /dev/dvb/adapter0 folder has contents.
> 
> Next thing is to test if it works with VDR. But I should warn you that other use the location as discribed in the Wiki. And upto three people have problems with the tutorial in combination with the TerraTec Cinergy S2 PCI HD where the system hangs on boot or during a manual modprobe.
> 

Is this the offending changeset ?

http://jusst.de/hg/mantis/rev/e466a650ef20

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
