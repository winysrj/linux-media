Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f205.google.com ([209.85.219.205])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <claesl@gmail.com>) id 1MLtRG-0005Pe-TY
	for linux-dvb@linuxtv.org; Wed, 01 Jul 2009 08:37:03 +0200
Received: by ewy1 with SMTP id 1so714747ewy.17
	for <linux-dvb@linuxtv.org>; Tue, 30 Jun 2009 23:36:29 -0700 (PDT)
Message-ID: <4A4B03E8.2000809@gmail.com>
Date: Wed, 01 Jul 2009 08:36:24 +0200
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, claesl@gmail.com
References: <4A4219E8.8000105@gmail.com>
In-Reply-To: <4A4219E8.8000105@gmail.com>
Subject: Re: [linux-dvb] Azurewave mantis problems
Reply-To: linux-media@vger.kernel.org
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

I have done some more testing and I have come to some more conclusions that
might be helpful.

Claes Lindblom wrote:
> Hi,
> I'm running Ubuntu server 9.04 amd64 with kernel 2.6.28-11-server kernel.
>
> When running s2-liplianin with my Azurewave AD-SP400 CI (Twinhan 
> VP-1041) it stops working after a while and
> if I do a dmesg I can see this every time it stops working. Sometimes 
> I have to poweroff my computer because a reboot
> will not fix the problem.
After 2-3 days of continues running szap-s2 on different channels 
without problems I started Mythtv and scheduled a recording.
The next day the error had appeared again and I get a lot of "Slave RACK 
Fail !". I power off the computer and starts it again.
Now I run scan-s2 with parameter "-a 0 -l UNIVERSAL -s 0 -n" for a 
complete network scan. When I check the computer again in
about an hour scan-s2 hangs and once again a lot of "Slave RACK Fail !" 
messages in dmesg.
As far as I can see it appears when scanning it goes wrong and I'm not 
sure but mythtv might do some scanning in the background?

>
> In this case it stopped working and then I tried to szap-s2 on the 
> loopback device, hence the loopback messages.
> And in this case a restart of sasc-ng solved the problem.
>
> [14121.882131] stb6100_set_frequency: Frequency=1588000
> [14121.890553] stb6100_get_frequency: Frequency=1587990
> [14123.462841] stb6100_set_bandwidth: Bandwidth=43750000
> [14123.471263] stb6100_get_bandwidth: Bandwidth=44000000
> [14123.592134] stb6100_set_frequency: Frequency=1588000
> [14123.600565] stb6100_get_frequency: Frequency=1587990
> [14125.172875] stb6100_set_bandwidth: Bandwidth=43750000
> [14125.181297] stb6100_get_bandwidth: Bandwidth=44000000
> [14125.302134] stb6100_set_frequency: Frequency=1588000
> [14125.310558] stb6100_get_frequency: Frequency=1587990
> [14125.558992] mantis stop feed and dma
> [14137.171642] mantis start feed & dma
> [14137.212838] stb6100_set_bandwidth: Bandwidth=55997500
> [14137.221261] stb6100_get_bandwidth: Bandwidth=56000000
> [14137.248250] stb6100_get_bandwidth: Bandwidth=56000000
> [14147.270027] mantis_ack_wait (0): Slave RACK Fail !
> [14147.270387] stb6100_set_frequency: Invalid parameter
> [14148.278112] dvblb_fake_ioctl interrupted: 2147774278
> [14149.270047] dvblb_fake_ioctl failed: 1
> [14149.392311] mantis stop feed and dma
> [14157.420024] mantis_ack_wait (0): Slave RACK Fail !
> [14157.420378] stb6100_get_frequency: Invalid parameter
> [14167.460056] mantis_ack_wait (0): Slave RACK Fail !
> [14167.460416] stb6100_get_bandwidth: Invalid parameter
> [14169.144614] dvbloopback: Got wrong response (2147774278 != 1)
> [14179.720049] mantis_ack_wait (0): Slave RACK Fail !
> [14179.720410] stb6100_set_bandwidth: Invalid parameter
> [14189.740037] mantis_ack_wait (0): Slave RACK Fail !
> [14189.740397] stb6100_get_bandwidth: Invalid parameter
> [14199.800030] mantis_ack_wait (0): Slave RACK Fail !
> [14199.800390] stb6100_get_bandwidth: Invalid parameter
> [14209.830047] mantis_ack_wait (0): Slave RACK Fail !
> [14209.830407] stb6100_set_frequency: Invalid parameter
> [14219.850026] mantis_ack_wait (0): Slave RACK Fail !
> [14219.850386] stb6100_get_frequency: Invalid parameter
> [14229.890048] mantis_ack_wait (0): Slave RACK Fail !
> [14229.890408] stb6100_get_bandwidth: Invalid parameter
> [14426.211181] mantis start feed & dma
> [14426.252841] stb6100_set_bandwidth: Bandwidth=55997500
> [14426.261263] stb6100_get_bandwidth: Bandwidth=56000000
> [14426.288250] stb6100_get_bandwidth: Bandwidth=56000000
> [14426.402142] stb6100_set_frequency: Frequency=1671000
> [14426.410572] stb6100_get_frequency: Frequency=1670994
> [14426.438715] stb6100_get_bandwidth: Bandwidth=56000000
>
> Then I tried the initial mantis trre mantis-v4l I have to modprobe 
> mantis to get it to load and the first channelscan with scan-s2
> did not work, the second time worked and third and above did not work. 
> Switching back to s2-liplianin it works again but stops working
> after a while. Today I used szap on a DVB-S2 channel and after that it 
> stopped working again.
>
> I have had dvbloopback loaded and sasc-ng running but my tuning was on 
> adapter 0 (not the loopback device)
>
> Does anyone have any thoughts or clues about this. It feels like the 
> driver are more unstable than about 6 month ago or it is
> something with my Gigiabyte motherboard.
>
> Regards
> Claes
>
Which S2API development branch for mantis is the best to use?

/Claes


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
