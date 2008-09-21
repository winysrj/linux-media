Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp114.rog.mail.re2.yahoo.com ([68.142.225.230])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jcoles0727@rogers.com>) id 1KhR7U-0002jK-D6
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 17:45:10 +0200
Message-ID: <48D66BE1.7020900@rogers.com>
Date: Sun, 21 Sep 2008 11:44:33 -0400
From: Jonathan Coles <jcoles0727@rogers.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
References: <48D658BF.7040807@rogers.com>
	<412bdbff0809210730i75f835cl54e48f70432dde1b@mail.gmail.com>
	<48D65E36.9070003@linuxtv.org>
In-Reply-To: <48D65E36.9070003@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Still unclear how to use Hauppage HVR-950
	and	v4l-dvb
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

Michael Krufky wrote:
> Devin Heitmueller wrote:
>   
>> On Sun, Sep 21, 2008 at 10:22 AM, Jonathan Coles <jcoles0727@rogers.com> wrote:
>>     
>>> It would really help if there was a single set of instructions specific
>>> to the HVR-950 with tests at each stage. I'm really confused as to the
>>> status of my installation.
>>>
>>> I compiled the firmware according to the instructions on
>>> http://linuxtv.org/repo/. The result:
>>>
>>> $ lsusb
>>> Bus 005 Device 002: ID 2040:7200 Hauppauge
>>>       
>> Hold the phone!  You don't have an HVR-950.  You have an HVR-950Q.
>> Please be sure to mention this in all future messages, since it's a
>> totally different device and the HVR-950 directions do not apply.
>>
>> I'm not sure whether the HVR-950Q support has been merged yet.  Steven
>> could comment on that.  I suspect it's still in a separate branch,
>> which would mean you would need to do an hg clone of a different tree.
>>     
>
>
> HVR950Q ATSC / QAM is supported in the master development repository, and it is in upstream 2.6.26 and later.
>
> You need the xc5000 firmware.
>
> [   17.247610] usb 5-2: new high speed USB device using ehci_hcd and 
> address 2
> [   17.380387] usb 5-2: unable to read config index 0 descriptor/all
> [   17.380434] usb 5-2: can't read configurations, error -71
>
>
> ^^ This is not a firmware problem, but looks fishy.  If using the latest drivers from linuxtv.org doesnt work for you, then try another USB port, or confirm that it also works in windows.
>
> Good Luck,
>
> Mike
>   
Thanks guys!

The box says HVR-950 on it and that the device "Cannot receive digital 
cable TV". However, the device itself is labeled "NTSC/ATSC/QAM HD TV 
receiver" and there is a small, stylized Q following the "950". Great! I 
got this on sale. Lack of QAM support was my reason for not buying 
earlier at the usual price. Perhaps the store didn't realize that this 
is the newer model.

I had added the XC5000 firmware, dvb-fe-xc5000-1.1.fw, in case I had a 
950Q. But if, as you say, I need a later kernel, that might be why it 
doesn't work. I have kernel 2.6.24-19.

I'll look for more info on linuxtv.org. Perhaps I just need to wait a 
little for the support for this to be developed.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
