Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from flexo.newnewyork.be ([91.121.117.137])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@bbackx.com>) id 1KgIpT-0003oV-GP
	for linux-dvb@linuxtv.org; Thu, 18 Sep 2008 14:41:52 +0200
To: Andrew Lyon <andrew.lyon@gmail.com>
MIME-Version: 1.0
Date: Thu, 18 Sep 2008 14:39:05 +0200
From: Ben Backx <ben@bbackx.com>
In-Reply-To: <f4527be0809180536sce988a1m800f55191e5f039d@mail.gmail.com>
References: <f4527be0809180536sce988a1m800f55191e5f039d@mail.gmail.com>
Message-ID: <52060c1f8d01ef7ce57ec31b93e06259@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] =?utf-8?q?Scan_Astra_28=2E8_no_ITV_HD=3F?=
Reply-To: ben@bbackx.com
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


On Thu, 18 Sep 2008 13:36:08 +0100, "Andrew Lyon" <andrew.lyon@gmail.com>
wrote:
> Hi,
> 
> I have scanned Astra 28.8 using dvbscan but it did not find ITV HD,
> can anybody give me the channel details so I can try to szap it
> manually?
> 
> Thanks
> Andy
> 

ITV HD is a little bit hidden :-)
You should find a service (I believe an audio service) with name 10510.
That's ITV HD.
Video PID is 3401, Audio PID is 11594, Service ID is 10510, PCR PID is 3401
and PMT PID is 3400.
That should give you ITV HD (but they aren't broadcasting all the time,
more chance on getting the test-screen right now.


regards,
Ben


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
