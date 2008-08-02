Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KPH59-0002l7-2M
	for linux-dvb@linuxtv.org; Sat, 02 Aug 2008 15:23:39 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1422585nfb.11
	for <linux-dvb@linuxtv.org>; Sat, 02 Aug 2008 06:23:35 -0700 (PDT)
Message-ID: <412bdbff0808020623i51f06490xf712706c5f932960@mail.gmail.com>
Date: Sat, 2 Aug 2008 09:23:35 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: deloptes@yahoo.com
In-Reply-To: <262763.82849.qm@web53204.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <mailman.61.1217648208.25488.linux-dvb@linuxtv.org>
	<262763.82849.qm@web53204.mail.re2.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] kernel 2.6.26 em28xx_dvb wrong firmware or other
	issue with HVR-900 rev A
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

HVR-900 support is now part of the standard v4ll-dvb codebase.

To get xc3027-v27.fw, just follow these directions:

http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware

Alternatively, as Markus pointed out, you can also use his codebase.

Devin

On Sat, Aug 2, 2008 at 3:34 AM, Emanoil Kotsev <deloptes@yahoo.com> wrote:
> Hello everybody,
>
> I wanted to try kernel 2.6.26 but couldn't start DVB tv - the error was
>
> firmware: requesting xc3028-v27.fw
> xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
>
> I read this firmware is related to HVR-950 but I have HVR-900 rev A which was fine with the v4l-dvb-experimental tree that I have been using with kenrel 2.6.20 and 2.6.24.
>
> Now I can not compile the v4l-dvb-experimental anymore.
>
> Could you help solve the issue please and thanks in advance
>
>
>
> regards
>
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
