Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.freemail.gr ([81.171.104.45])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <scoop_yo@freemail.gr>) id 1MfbHP-0003ZK-QX
	for linux-dvb@linuxtv.org; Mon, 24 Aug 2009 17:16:20 +0200
From: scoop_yo@freemail.gr
To: linux-dvb@linuxtv.org
Date: Mon, 24 Aug 2009 18:16:14 +0300
Message-Id: <4a92aebed8d243.51797805@freemail.gr>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="=_4a92aebf18c729.41803005=_";
Subject: Re: [linux-dvb] Lifeview hybrid saa7134 driver not working anymore
Reply-To: linux-media@vger.kernel.org, scoop_yo@freemail.gr
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

To l^mula aut| e_mai se loqv^ MIME. E\m to pq|cqalla akkgkocqav_ar sar dem jatakaba_mei
aut^ tg loqv^, ]ma l]qor ^ to s}moko tou lgm}lator lpoqe_ ma lg diab\fetai.

--=_4a92aebf18c729.41803005=_
Content-Type: text/plain; charset="iso-8859-7"

I am sorry if this messages gets delivered twice. It seems that I have some problems with the outgoing mail server. Feel free to delete the double copy :)

> > Considering your reply, I started today by changing the card to all PCI slots and powering on and off the machine each time, until when I put the card to the bottom PCI it worked again ! Then I tried all other slots again and it was working this time. That is some weird card behaviour !
> 
> It is still a very unpleasant situation for all involved, for you of
> course in the first place.
> 
> But until it should not be a single problem report anymore,for now it
> is, we have good reasons, to start questioning about the PSU in use and
> its current shape, the mobo distributing the voltage further, and in the
> end too, if something like a capacitor on the card itself starts
> leaking.
> 
> After all that, unfortunately, programming still can be a point, of
> course, but it did not change within that driver since long.
> 
> However, others operating on a higher level, can
> introduce_something/clear/fail_at_all on such too.
> 
> If you can't get out of that random, but windows always works, I guess
> we have a performance problem on your hardware ;)
> 
> Cheers,
> Hermann

It seems that I rushed into conclusions, but I managed to reproduce the problem.

The card stops working when I boot to my 64bit Linux system.
With my 32bit Linux and Windows XP 32 bit the card is working, but if I boot my 64bit Linux the card won't work there and after that boot the card stops working in all three OSes.
To make the card work again I have to switch off power & remove power cable and remove and place again the card to the PCI slot. (Not sure if that last part is needed) 
Then again the card works on Linux 32bit and Windows XP until I boot my 64bit 
Linux.

I use the same latest revision of `v4l-dvb' on both Linux 32bit & 64bit and latest vanilla 2.6.30.5. I also use the same firmware, but it seems that when I boot 64bit Linux some problems come up with the firmware.. I don't get why this happens since the firmware that I use is the same and I verified that by comparing those two files @ /lib/firmware :
dvb-fe-tda10045.fw
dvb-fe-tda10046.fw


I used the command bellow to load the module and I have attached two logs on a zip file:

# modprobe saa7134 i2c_debug=1 i2c_scan=1 disable_ir=1 core_debug=1


1st log: The error log that I get for the first time that I boot to 64bit Linux. Until that boot the card is working. After that boot it stops working.

2st log: The log that I get in my 32bit Linux when the card is working.


When the card stops working I get the error log that I attached in my first message.


--=_4a92aebf18c729.41803005=_
Content-Type: application/zip
Content-Disposition: attachment; filename="logs.zip"
Content-Transfer-Encoding: base64

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

--=_4a92aebf18c729.41803005=_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=_4a92aebf18c729.41803005=_--
