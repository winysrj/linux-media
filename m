Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail04.syd.optusnet.com.au ([211.29.132.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lindsay.mathieson@blackpaw.dyndns.org>)
	id 1LQ9y7-0008LF-8N
	for linux-dvb@linuxtv.org; Fri, 23 Jan 2009 01:32:21 +0100
Received: from blackpaw.dyndns.org (c122-108-213-22.rochd4.qld.optusnet.com.au
	[122.108.213.22]) (authenticated sender lindsay.mathieson)
	by mail04.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	n0N0W6f0013866
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 11:32:09 +1100
Received: from blackpaw.dyndns.org (unverified [127.0.0.1])
	by blackpaw.dyndns.org (SurgeMail 4.0a) with ESMTP id 715-1769969
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 10:32:06 +1000
From: "Lindsay Mathieson" <lindsay.mathieson@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 23 Jan 2009 10:32:05 +1000
Message-id: <49791005.3e3.51bd.2018512498@blackpaw.dyndns.org>
MIME-Version: 1.0
Subject: [linux-dvb] TinyTwin (af9015) Results and questions
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

I've pulled the latest v4l-dvb trunk and installed it, can
confirm that both tuners of the DigitalNow TinyTwin work
beautifully. I do have a few questions though.

- I still have to specify:
  options dvb-usb-af9015 dual_mode=1

to enable the second tuner. I thought that would be on by
default now the 2nd tuner bugs have been worked out. 

- Is there a official place to download the firmware from?
Currently I'm getting it from:
 
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw

- Is it possible to estimate when this will make its way
into the linux kernel? How will I know?

I ask because I'd like to write up a howto for myth and/or
ubuntu users, and want to cover all bases.

Thanks - Lindsay

Lindsay Mathieson
http://members.optusnet.com.au/~blackpaw1/album

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
