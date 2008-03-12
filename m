Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JZYVZ-0004nO-BE
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 22:29:09 +0100
Message-ID: <47D84B15.1030608@linuxtv.org>
From: mkrufky@linuxtv.org
To: jarro.2783@gmail.com
Date: Wed, 12 Mar 2008 17:28:53 -0400
MIME-Version: 1.0
in-reply-to: <abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>
Cc: crope@iki.fi, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

Jarryd Beck wrote:
> On Thu, Mar 13, 2008 at 8:14 AM,  <mkrufky@linuxtv.org> wrote:
>   
>>  Then, please turn ON debug, repeat your tests, and post again with
>>  dmesg.  I am not familiar with the af9015 driver, but for tda18271, set
>>  debug=1.  (you must unload all modules first -- do 'make unload' in the
>>  v4l-dvb dir, then replug your device)
>>     
> Sorry I'm unsure where to set debug.
>   
You have two options.

option 1)

after unloading all modules, load the given module with the debug insmod 
option.

To see the available insmod options, use modinfo.  For instance, 
'modinfo tda18271' will show you the tuner drivers available options.

Load the driver using the option, "modprobe tda18271 debug=1" ... then 
plug in the stick.

...

option 2)

set the insmod option in your boot script.  I run Ubuntu... to enable 
debug for my tuner. i edit /etc/modprobe.d/options and add the following 
line:

options tda18271 debug=1

...then unload all modules, and replug the stick...   or reboot your 
machine, then replug the stick.

regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
