Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47E796E6.3080600@iki.fi>
Date: Mon, 24 Mar 2008 13:56:22 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47DC64F4.9070403@iki.fi>
	<47DC6E0A.9000904@linuxtv.org>	<abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>	<47DC8012.3050809@linuxtv.org>	<abf3e5070803152025q14dd3e03tc8230940fe50e1b@mail.gmail.com>	<47DC93D0.3090904@linuxtv.org>
	<47DF2576.7080907@iki.fi>	<abf3e5070803191901w14e4b827k8dd90fb202cafc6e@mail.gmail.com>	<47E1CC07.8050006@iki.fi>
	<abf3e5070803232232r2fef9b8ap4ea0a525181234a5@mail.gmail.com>
In-Reply-To: <abf3e5070803232232r2fef9b8ap4ea0a525181234a5@mail.gmail.com>
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
>>  Thanks, I removed obsolete trees.
> 
> I've tried it with the updated af9015 branch, it works perfectly, the
> lock LED has even decided to come on.
> There's one problem which I've noticed from the start, while it's
> plugged in, random number key presses
> are being registered. Any ideas about what could be causing that and
> how to stop it? lirc is disabled.
> I'm guessing it's something to do with this from dmesg:
> 
> input: Leadtek WinFast DTV Dongle Gold as /class/input/input21
> input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
> usb-0000:00:02.1-2
> 
> Jarryd.

Yes, it is remote controller. It should be disabled or enabled regarding 
eeprom value. But I don't know how to do that. Anyhow, you can do that 
manually setting option dvb_usb disable_rc_polling=1

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
