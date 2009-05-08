Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from psmtp08.wxs.nl ([195.121.247.22])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan-conceptronic@hoogenraad.net>) id 1M2To0-000692-Tt
	for linux-dvb@linuxtv.org; Fri, 08 May 2009 19:24:17 +0200
Received: from localhost.sitecomwl312
	(ip545779c6.direct-adsl.nl [84.87.121.198])
	by psmtp08.wxs.nl (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov
	14 2006)) with ESMTP id <0KJC00LWL5NDIJ@psmtp08.wxs.nl> for
	linux-dvb@linuxtv.org; Fri, 08 May 2009 19:23:43 +0200 (MEST)
Date: Fri, 08 May 2009 19:23:36 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
In-reply-to: <1241775561.7996.8.camel@McM>
To: Miguel <mcm@moviquity.com>
Message-id: <4A046A98.40806@hoogenraad.net>
MIME-version: 1.0
References: <1241775561.7996.8.camel@McM>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T USB stick  azurewave AD-TU200
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

Miguel:

Can you provide the version of the software you use, and the way you 
have installed rtl2831u software (e.g. a link to the instructions) ?

The latest version should be located at:
http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2

This driver INDEED has no separate front-end: the MXL500x code is 
incorporated integrally in the code.
I did not know anybody with a rtl2831/MXL500x combination yet,
as all users I know had a  rtl2831/MT2060 combination.

It should work without frontend, as the code is included.

Miguel wrote:
> Hi all,
> 
> I am searching information about how to get my dvb-t usb stick works 
> with my machine.
> 
> I currently using a ubuntu intrepid os. I have installed the rtl2831u 
> drivers as it is recommended.
> 
> *TwinHan/AzureWave AD-TU200 (7047) DVB-T 
> <http://www.twinhan.com/product_AD-TU200.asp> *
> Uses a Realtek RTL2831U decoder chip and MaxLinear 
> <http://www.linuxtv.org/wiki/index.php?title=MaxLinear&action=edit> 
> MXL5003S <http://www.linuxtv.org/wiki/index.php/MXL5003S> tuner. USB ID 
> is 13d3:3216. It seems to work with the realtek experimental driver (see 
> freecom v4 above)
> 
> The problems I have found:
> 
> The found device  has not frontend:
> 
> mcm@McM:/usr/share/doc/dvb-utils$ tree /dev/dvb/adapter0/
> /dev/dvb/adapter0/
> |-- demux0
> |-- dvr0
> `-- net0
> 
> So when scanning it fails
> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> main:2247: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 2 No 
> such file or directory
> 
> Other problem I found, which GUI is recommended to be used?
> 
> thank you in advance,
> 
> Miguel
> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
