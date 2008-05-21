Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtphost.cis.strath.ac.uk ([130.159.196.96])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gnapier@cis.strath.ac.uk>) id 1Jyo7c-0002bM-6k
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 15:12:49 +0200
Message-ID: <48341FBD.7080603@cis.strath.ac.uk>
Date: Wed, 21 May 2008 14:12:29 +0100
From: Gary Napier <gnapier@cis.strath.ac.uk>
MIME-Version: 1.0
To: Dennis Schwan <dennis.schwan@leuchtturm-it.de>
References: <48341B25.2070306@leuchtturm-it.de>
In-Reply-To: <48341B25.2070306@leuchtturm-it.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with cx88
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

Dennis,
Im not certain what your card is, but my hvr-3000 uses the same modules. 
It seems in a bid to fix some
bug or other, hardy has its own cx88 module among others, and even if 
you build your own, it uses its own, which seems
to be broken for DVB-S. The solution so far is to delete its copy and 
build your own...

Hope it helps, but anyone with more experience should probably chip in 
here esp if i have it all wrong

(Optional) Remove modules from *buntu 8.04

This step is only required if you are running an Ubuntu variant, after one of their bug fixes duplicated the modules being run.
This also may be useful to anyone who gets dmesg errors like : cx88xx: disagrees about version of symbol (videobuf_dma_free)

# rm -rf /lib/modules/`uname -r`/ubuntu/media/cx88
# rm -rf /lib/modules/`uname -r`/ubuntu/media/saa7134
# depmod -a



Dennis Schwan wrote:
> Hi,
>
> I have problems with my Hauppauge Nova-S Card. It works mostly but i 
> have problems when watching Live-TV on a MythTV Client.
> The Errors ind the Backends Syslog are as follows:
>
> May 21 14:49:38 myth kernel: [  319.630976] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:39 myth kernel: [  320.638820] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:40 myth kernel: [  321.646477] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:41 myth kernel: [  322.654081] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:42 myth kernel: [  323.661852] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:43 myth kernel: [  324.669599] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:44 myth kernel: [  325.677362] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:45 myth kernel: [  326.685118] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:46 myth kernel: [  327.691986] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:47 myth kernel: [  328.700559] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:48 myth kernel: [  329.707352] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:49 myth kernel: [  330.714884] cx88[0]/2-mpeg: general 
> errors: 0x00000100
> May 21 14:49:50 myth kernel: [  331.722389] cx88[0]/2-mpeg: general 
> errors: 0x00000100
>
> When i reload the driver and just use my budget-card everything works 
> fine, so i really need a solition for this.
> The card worked without problems before upgrading to Ubuntu Hardy/8.04
>
> The problem occurs with the default Ubuntu drivers and also with newes 
> CVS drivers.
>
> Regards,
> Dennis
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   

-- 
_____________________________________________________________________________
Gary Napier


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
