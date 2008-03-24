Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47E7974E.8070303@iki.fi>
Date: Mon, 24 Mar 2008 13:58:06 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47DC6E0A.9000904@linuxtv.org>	<abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>	<47DC8012.3050809@linuxtv.org>	<abf3e5070803152025q14dd3e03tc8230940fe50e1b@mail.gmail.com>	<47DC93D0.3090904@linuxtv.org>
	<47DF2576.7080907@iki.fi>	<abf3e5070803191901w14e4b827k8dd90fb202cafc6e@mail.gmail.com>	<47E1CC07.8050006@iki.fi>	<abf3e5070803232232r2fef9b8ap4ea0a525181234a5@mail.gmail.com>
	<abf3e5070803232235r49d73442tc7ce603043778e7a@mail.gmail.com>
In-Reply-To: <abf3e5070803232235r49d73442tc7ce603043778e7a@mail.gmail.com>
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

Jarryd Beck wrote:
> Also I just remembered the signal is being reported as 0% by mythtv,
> although it is still
> locking fine and the picture is perfect. It works fine with another
> tuner so I'm guessing
> it's something specifically to do with that tuner.
> 
> Jarryd.

No it is not tuner issue, AF9013 driver does not support signal 
reporting currently.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
