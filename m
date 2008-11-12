Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1L06Kh-0003ig-9g
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 04:23:57 +0100
Received: by fg-out-1718.google.com with SMTP id e21so228564fga.25
	for <linux-dvb@linuxtv.org>; Tue, 11 Nov 2008 19:23:51 -0800 (PST)
Message-ID: <37219a840811111923p68a2916fkc8844809197ffd5@mail.gmail.com>
Date: Tue, 11 Nov 2008 22:23:50 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: CityK <cityk@rogers.com>
In-Reply-To: <491A3E6E.6020303@rogers.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <11925882.1226435183455.JavaMail.root@elwamui-ovcar.atl.sa.earthlink.net>
	<491A3E6E.6020303@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] FusionHDTV7 RT Gold
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

On Tue, Nov 11, 2008 at 9:24 PM, CityK <cityk@rogers.com> wrote:
> William Melgaard wrote:
>> I have a DViCO FusionHDTV7 RT Gold PCI card in my posession. To date, I cannot make it work with my AMD64 Debian (stable) box. This card is not to be confused with the Dual Express or the USB cards
>>
>> I am getting mixed answers to request for support.
>> I have been told that the card is supported. I downloaded the latest Mercurial, and installed it. As far as I can tell, the FusionHDTV7 RT Gold is NOT supported by the latest Mercurial. If it is, please provide configuration instructions.
>>
>> If the RT Gold is not yet supported, what can I do to aid in providing support? I have some c programming skills, but have never dealt with a driver.
>>
> see: http://marc.info/?l=linux-dvb&m=120165779828786&w=2
>
> I don't know if Steve submitted the drivers or not ... they may reside
> in one of his development repositories
>

I added analog support for this card on Feb 25 of this year.  Digital
support was merged shortly thereafter.

Most likely, you are simply missing the firmware.  If you check your
kernel logs, it is more than likely that this will be mentioned there.

You can fetch the firmware from http://steventoth.net/linux/xc5000

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
