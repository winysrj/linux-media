Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp100.rog.mail.re2.yahoo.com ([206.190.36.78])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JOZ9D-00027L-Jj
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 14:56:39 +0100
Message-ID: <47B053E0.4060000@rogers.com>
Date: Mon, 11 Feb 2008 08:55:44 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: Pierre Cassimans <cazzeml@gmail.com>
References: <638226.79716.qm@web57814.mail.re3.yahoo.com>	<20080211110428.GD30853@localhost>
	<a3fb6570802110405h77809db5j8e4b54b23a002c9b@mail.gmail.com>
In-Reply-To: <a3fb6570802110405h77809db5j8e4b54b23a002c9b@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hi
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Pierre Cassimans wrote:
> Just keep in mind that when you want to record HD content from the 3 
> cards, you have 3 x 20MB/s and mostly this is more then your HardDisk 
> can get :)

That is incorrect.  hdd saturation is not an issue. Examples:

TS for 8-VSB source:  ~19.4Mbps (~2.4MBps)
TS for 64-QAM source: ~27Mbps (~3.4MBps)
TS for 256-QAM source: ~38.8Mbps (~4.8MBps)
....
insert other rates here
....
....

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
