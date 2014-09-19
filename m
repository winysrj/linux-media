Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <knueffle@yahoo.com>) id 1XV6ct-0003Yw-8e
	for linux-dvb@linuxtv.org; Sat, 20 Sep 2014 00:26:03 +0200
Received: from nm43-vm9.bullet.mail.bf1.yahoo.com ([216.109.114.170])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-7) with esmtps
	[UNKNOWN:AES256-GCM-SHA384:256] for <linux-dvb@linuxtv.org>
	id 1XV6cr-0000xc-1v; Sat, 20 Sep 2014 00:26:03 +0200
Message-ID: <1411165558.12042.YahooMailNeo@web140002.mail.bf1.yahoo.com>
Date: Fri, 19 Sep 2014 15:25:58 -0700
From: Jody Gugelhupf <knueffle@yahoo.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] dvb-s - how to obtain PMT (Program Map Table) and
	w_scan syntax explanation
Reply-To: linux-media@vger.kernel.org, Jody Gugelhupf <knueffle@yahoo.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

hi all,

I'm using a DVB-s card (tbs6991), in combination with tvheadend to stream to clients on the lan. Mainly it works pretty good, but from time to time there are some mux where the PMT values for some stations are missing when adding the mux. I managed to find out how to add the PMT values manually. So far I was obtaining the PMT values from kingofsat.net but also there some are missing and I would like to be able to get these values somehow myself. Can w_scan be used for that or is there any other tool for it?
In addition I was trying to find out what all the values in my w_scan file mean, for instance a scan like this:

w_scan -fs -s S42E0 -D 2c -o2 -F -C ISO8859-9 > turksat.channel.conf

results in entries likes these:

TGRT BELGESEL;www.tgrt.com.tr:11981:hC56M2O0S0:S42E:5200:308=2:256=eng@4:0:0:1:42:313:0
SHOW TV;SHOW TV:11964:hC34M2O0S0:S42E:5925:308+8190=2:256=tur@4,257=alm,258=ifb:273:0:1:90:19:0

I tried to figure out all the output syntax and got so far:

Channel Name : Provider : frequency : polarization : orbital position : symbol rate : video pid and PCR *(if vpid and pcr are the same then vpid=2 seems to apply)* : audiopid=language : videotext pid : conditional access (probably) : service ID (sometime equal to PMT): *don't know* : *don't know* : *don't know*

can someone confirm or correct my interpretation? and again is it somehow possible to get the PMT value in the output as well.
If i'm not mistaken I can get PMT values at lest in hex format when using dvbsnoop, but then if I want to get the values for 3 satellites (my current setup) that would imply a veeery lengthy process I think, unless someone can give me some pointers (or a solution preferable ;-)).

Thank you in advance for any help :-)
Jody

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
