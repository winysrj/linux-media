Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f12.google.com ([209.85.219.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1LNXBm-0002J2-Bf
	for linux-dvb@linuxtv.org; Thu, 15 Jan 2009 19:43:35 +0100
Received: by ewy5 with SMTP id 5so27467ewy.17
	for <linux-dvb@linuxtv.org>; Thu, 15 Jan 2009 10:42:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <28014750.1231552542526.JavaMail.root@elwamui-darkeyed.atl.sa.earthlink.net>
References: <28014750.1231552542526.JavaMail.root@elwamui-darkeyed.atl.sa.earthlink.net>
Date: Thu, 15 Jan 2009 10:42:58 -0800
Message-ID: <cae4ceb0901151042n433d0810m73067ced245cccca@mail.gmail.com>
From: Tu-Tu Yu <tutuyu@usc.edu>
To: William Melgaard <piobair@mindspring.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Does anyone work on Dvico HDTV7 (both s5h1411 and
	s5h1409) sucessfully!?
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

Hi there:
Thank you Bill and Michael.
I tried to move it on different slot and I also check the cabling. It
still will crash after few hours. The card with s5h1409 usually can
last for 10 or more hours but the card with s5h1411 can only last for
at most 2 hours. I am using kernel 2.6.26 and then I am using linux
fedora 4. So do you think it might be my kernel or my operating
system?
Best,
Audrey


On Fri, Jan 9, 2009 at 5:55 PM, William Melgaard <piobair@mindspring.com> wrote:
> If nothing is being saved: the program is only processing a stream, then duration is inconsequential. The state (dump) at t=0 thus is identical to the state just before crash. It follows that you have a hardware (heat?) problem. Try moving the card to a different slot.
>
> Bill
> -----Original Message-----
>>From: Tu-Tu Yu <tutuyu@usc.edu>
>>Sent: Jan 9, 2009 2:28 PM
>>To: linux-dvb@linuxtv.org
>>Subject: [linux-dvb] Does anyone work on Dvico HDTV7 (both s5h1411 and s5h1409) sucessfully!?
>>
>>hi~
>>I am working on Dvico HDTV7 Tv tuner card. For s5h1409 version, it
>>usually works fine in first few hours but after a while it will stop.
>>For S5H1411 version, it usually works fine for only first hours and
>>then it will stop....Can anyone give me some suggestion? I am looking
>>for the solution for more than 1 month.....? Thank you so much!
>>Audrey
>>
>>_______________________________________________
>>linux-dvb users mailing list
>>For V4L/DVB development, please use instead linux-media@vger.kernel.org
>>linux-dvb@linuxtv.org
>>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
