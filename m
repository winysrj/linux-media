Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static.135.41.46.78.clients.your-server.de ([78.46.41.135]
	helo=hetzner.kompasmedia.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bas@kompasmedia.nl>) id 1K1RAD-0006nF-6l
	for linux-dvb@linuxtv.org; Wed, 28 May 2008 21:18:22 +0200
Message-ID: <483DAFF8.5000500@kompasmedia.nl>
Date: Wed, 28 May 2008 21:18:16 +0200
From: "Bas v.d. Wiel" <bas@kompasmedia.nl>
MIME-Version: 1.0
To: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
References: <482EB3E5.7090607@freenet.de>	<482F49BB.4060300@gmail.com>	<48327AEF.1060809@freenet.de>	<48371567.8080304@gmail.com>	<20080523212816.e3l3sl8pccg08ogc@192.168.1.1>
	<483DAD23.9060507@freenet.de>
In-Reply-To: <483DAD23.9060507@freenet.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] CAM of Mantis 2033 still not working
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

Hi,
I'm running 2.6.24-16 64-bit, and I get a whole stream of errors 
(writing to registers fails) from the frontend whether or not the cam is 
inserted. I don't get any hard crashes anymore when I insert the CAM, 
but there's still my previous problem of not being able to find any 
signal/channels whatsoever using w_scan and a constant stream of 'tuning 
failure' from dvb-scan. Femon also shows everything as zero values, 
except the snr ration which is completely maxed out.

Bas

Ruediger Dohmhardt wrote:
> I just tried the changeset from today (7348 0b04be0c088a)
>
> My machine still crashes, when inserting "mantis.ko"
>
> The last running changeset (of course without CAM functionality) for me is:
>
> 7328 - d371e22416dd   from   21. Mai .08
>
> Am I the only one, who uses 2.6.22.19  (64bit)?
> Shall I switch the kernel version?
>  
> Ciao Ruediger D.
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
