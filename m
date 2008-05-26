Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zac.spitzer@gmail.com>) id 1K0Z0u-0001vW-9R
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 11:29:09 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1898538wag.13
	for <linux-dvb@linuxtv.org>; Mon, 26 May 2008 02:29:02 -0700 (PDT)
Message-ID: <7a85053e0805260229v151b2bc2q1f34d2143aa5539e@mail.gmail.com>
Date: Mon, 26 May 2008 19:29:02 +1000
From: "Zac Spitzer" <zac.spitzer@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <200805260420.59067.bumkunjo@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080525112820.374AC104F0@ws1-3.us4.outblaze.com>
	<200805260420.59067.bumkunjo@gmx.de>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
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

which pci id is this for? I have a dual digitial 4 (rev 2 ) which is 0fe9:db98

On Mon, May 26, 2008 at 12:20 PM,  <bumkunjo@gmx.de> wrote:
>
> Thanks for the patch, Frieder - it seems to work perfectly on my vdr box - all
> channels tune - good reception.
> i will report if any issues appear. if I can help testing upcoming versions of
> the driver ask me.
>
> Thanks a lot to Chris and Stephen for your work,
>
> Jochen
>
> Am Sonntag 25 Mai 2008 13:28:20 schrieb stev391@email.com:
>>  Hans-Frieder,
>>
>> Thanks, for this patch.  I have tested it on 1 of 3 machines that I have
>> access to with this DVB card. No issues (Now loads 80 firmwares, instead
>> of 3)
>>
>> It doesn't break Chris Pascoe's xc-test branch with the DViCO Fusion HDTV
>> DVB-T Dual Express.
>>
>> It also makes my patch, to get support into the v4l-dvb head, (newer
>> version then posted here) work a lot more reliably (Perfectly on this
>> test machine, I will run it on my mythbox for a week or so before I post
>> it).
>>
>> I think you should email Chris Pascoe and petition him to include it in
>> his branch.  As this will definitely help alot of people out.
>>
>> Thanks again,
>>
>> Stephen.
>>
>>   ----- Original Message -----
>>   From: "Hans-Frieder Vogt"
>>   To: "jochen s" , stev391@email.com
>>   Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
>>   Date: Fri, 23 May 2008 21:46:58 +0200
>>
>>
>>   Jochen,
>>
>>   you are indeed missing firmwares. The xc-test branch from Chris
>>   Pascoe uses the special collection of firmwares
>>   xc3028-dvico-au-01.fw which only contains firmwares for 7MHz
>>   bandwidth (just try to tune a channel in the 7MHz band to confirm
>>   this). To make the card work also for other bandwidths please apply
>>   the following patch and put the standard firmware for xc3028
>>   (xc3028-v27.fw) in the usual place (e.g. /lib/firmware).
>>
>>   This approach should also work for australia, because the standard
>>   firmware also contains those firmwares in xc3028-dvico-au-01.fw.
>>
>>   Stephen, can you confirm this?
>>
>>   Cheers,
>>   Hans-Frieder
>>
>>   --- xc-test.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c
>>   2008-04-26 23:40:52.000000000 +0200
>>   +++ xc-test/linux/drivers/media/video/cx23885/cx23885-dvb.c
>>   2008-05-19 23:15:08.000000000 +0200
>>   @@ -217,9 +217,9 @@ static int dvb_register(struct cx23885_t
>>   .callback = cx23885_dvico_xc2028_callback,
>>   };
>>   static struct xc2028_ctrl ctl = {
>>   - .fname = "xc3028-dvico-au-01.fw",
>>   + .fname = "xc3028-v27.fw",
>>   .max_len = 64,
>>   - .scode_table = ZARLINK456,
>>   + .demod = XC3028_FE_ZARLINK456,
>>   };
>>
>>   fe = dvb_attach(xc2028_attach, port->dvb.frontend,
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
Zac Spitzer -
http://zacster.blogspot.com (My Blog)
+61 405 847 168

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
