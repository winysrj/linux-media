Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JdlLb-0005AL-CM
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 13:00:21 +0100
Received: by ti-out-0910.google.com with SMTP id y6so659753tia.13
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 04:59:57 -0700 (PDT)
Message-ID: <abf3e5070803240459m73ff147ajdc7bea5727a26c04@mail.gmail.com>
Date: Mon, 24 Mar 2008 22:59:57 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47E7974E.8070303@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>
	<47DC8012.3050809@linuxtv.org>
	<abf3e5070803152025q14dd3e03tc8230940fe50e1b@mail.gmail.com>
	<47DC93D0.3090904@linuxtv.org> <47DF2576.7080907@iki.fi>
	<abf3e5070803191901w14e4b827k8dd90fb202cafc6e@mail.gmail.com>
	<47E1CC07.8050006@iki.fi>
	<abf3e5070803232232r2fef9b8ap4ea0a525181234a5@mail.gmail.com>
	<abf3e5070803232235r49d73442tc7ce603043778e7a@mail.gmail.com>
	<47E7974E.8070303@iki.fi>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
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

On Mon, Mar 24, 2008 at 10:58 PM, Antti Palosaari <crope@iki.fi> wrote:
> Jarryd Beck wrote:
>  > Also I just remembered the signal is being reported as 0% by mythtv,
>  > although it is still
>  > locking fine and the picture is perfect. It works fine with another
>  > tuner so I'm guessing
>  > it's something specifically to do with that tuner.
>  >
>  > Jarryd.
>
>  No it is not tuner issue, AF9013 driver does not support signal
>  reporting currently.
>
>
>
>  regards
>  Antti
>  --
>  http://palosaari.fi/
>

Actually I meant the device in general. That explains the lack
of signal though, thanks.

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
