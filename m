Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx-02.fra.se ([194.18.169.36])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ola.ekedahl@fra.se>) id 1KW4Qi-0005N5-SC
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 09:18:01 +0200
Message-ID: <48AD16A1.5040703@fra.se>
Date: Thu, 21 Aug 2008 09:17:53 +0200
From: Ola Ekedahl <ola.ekedahl@fra.se>
MIME-Version: 1.0
To: Gregoire Favre <gregoire.favre@gmail.com>
References: <48ABB045.5050301@fra.se> <20080820082010.GA5582@gmail.com>
In-Reply-To: <20080820082010.GA5582@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto, multiproto_plus & mantis
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

Gregoire Favre skrev:
> On Wed, Aug 20, 2008 at 07:48:53AM +0200, Ola Ekedahl wrote:
>   
>> Hi,
>>
>> I have been trying to compile the three different trees in Fedora 7, but 
>> all fails with alot of warnings and errors. What are the recomended 
>> specification for the kernel, wont it compile with the kernel in Fedora 7?
>>     
>
> AFAIK the only actively maintened tree is :
> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/liplianindvb/
>
> Wanny try this one ?
>   
I tried to compile the driver, but it failed too. I got the following 
error after quite some time:

  LD [M]  /home/kurt/Desktop/liplianindvb/v4l/sms1xxx.o
  CC [M]  /home/kurt/Desktop/liplianindvb/v4l/s400.o
/home/kurt/Desktop/liplianindvb/v4l/s400.c: In function 's400_ir_init':
/home/kurt/Desktop/liplianindvb/v4l/s400.c:508: error: 'struct 
input_dev' has no member named 'dev'
make[3]: *** [/home/kurt/Desktop/liplianindvb/v4l/s400.o] Error 1
make[2]: *** [_module_/home/kurt/Desktop/liplianindvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.21-1.3194.fc7-i686'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/kurt/Desktop/liplianindvb/v4l'
make: *** [all] Error 2



Anyone have any idea? Is it because of the dist Im running?

Best regards

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
