Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1L3cfi-0002lV-4b
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 21:32:11 +0100
Message-ID: <49271AC1.7040801@gmail.com>
Date: Sat, 22 Nov 2008 00:32:01 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Terry Barnaby <terry1@beam.ltd.uk>
References: <492568A2.4030100@beam.ltd.uk> <492691B9.1080809@beam.ltd.uk>
	<492692D2.2000009@beam.ltd.uk>
In-Reply-To: <492692D2.2000009@beam.ltd.uk>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Take 2: Re: Twinhan VisionPlus DVB-T Card
 not working
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

Terry Barnaby wrote:
> Terry Barnaby wrote:
>> Terry Barnaby wrote:
>>> Hi,
>>>
>>> I am having a problem with the latest DVB drivers.
>>> I have a Twinhan VisionPlus DVB-T card (and other DVB cards) in my
>>> MythTv server running Fedora 8. This is running fine
>>> with the Fedora stock kernel: 2.6.26.6-49.fc8.
>>>
>>> However, I have now added a Hauppauge DVB-S2 and so have been
>>> trying the latest DVB Mercurial DVB tree.
>>> This compiles and installs fine and the two DVB-T cards and the
>>> new DVB-S card are recognised and has /dev/dvb entries.
>>> The first DVB-T card, a Twinhan based on the SAA7133/SAA7135
>>> works fine but the Twinhan VisionPlus, which is Bt878 will not
>>> tune in.
>>>
>>> Any ideas ?
>>> Has there been any recent changes to the Bt878 driver that could
>>> have caused this ?
>>>
>> I have tracked this down to a bug in the bt8xx/dst frontend.
>> It appears that the front end tuning algorithm number as used in
>> dvb_frontend.c has changed format but the default setting in
>> bt8xx/dst has not been updated to match.
>>
>> This patch sets the default algorithm to be software tuning as,
>> I believe, was the original setting. However, I wonder if
>> it should be set to use hardware tuning by default ...
>>
>>
>> Cheers
>>
>>
>> Terry
>>
> This is a better patch as it describes the integer values
> that can be used as options.
> 
> Cheers
> 
> 
> Terry
> 
> 
> ------------------------------------------------------------------------
> 
> diff -r 5dc4a6b381f6 linux/drivers/media/dvb/bt8xx/dst.c
> --- a/linux/drivers/media/dvb/bt8xx/dst.c	Wed Nov 19 13:01:33 2008 -0200
> +++ b/linux/drivers/media/dvb/bt8xx/dst.c	Fri Nov 21 10:50:00 2008 +0000
> @@ -38,9 +38,9 @@ module_param(dst_addons, int, 0644);
>  module_param(dst_addons, int, 0644);
>  MODULE_PARM_DESC(dst_addons, "CA daughterboard, default is 0 (No addons)");
>  
> -static unsigned int dst_algo;
> +static unsigned int dst_algo = DVBFE_ALGO_SW;
>  module_param(dst_algo, int, 0644);
> -MODULE_PARM_DESC(dst_algo, "tuning algo: default is 0=(SW), 1=(HW)");
> +MODULE_PARM_DESC(dst_algo, "tuning algo: default is 2=DVBFE_ALGO_SW (options: 1=DVBFE_ALGO_HW)");
>  
>  #define HAS_LOCK		1
>  #define ATTEMPT_TUNE		2


Can you please add in your Developer Certificate of Origin
Signed-off-by: User.Name <user.name@domain.name>

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
