Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gujs.lists@gmail.com>) id 1K4Bus-0005dz-Rl
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 11:37:55 +0200
Received: by gv-out-0910.google.com with SMTP id n29so204175gve.16
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 02:37:50 -0700 (PDT)
Message-ID: <4847B3F0.1030501@gmail.com>
Date: Thu, 05 Jun 2008 11:37:52 +0200
From: Gregor Fuis <gujs.lists@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org,
	Mailing list for VLC media player developers <vlc-devel@videolan.org>
Subject: [linux-dvb] multiproto and vlc
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

Hello

I am using the latest multiproto from Manu's repository with KNC1 DVB-S2 
card. I patched drivers with multiproto-support-old-api.dif patch which 
enables drivers for older DVB api. When I watch programs with vlc i get 
a lot of discontinuity error. I was measuring how frequently they are 
appearing and came to an interesting finding. It looks like they are 
appearing in every 10 seconds (+- 1 second).

But if I use szap to select channel and then open dvr0, the stream is 
working great and without any errors.

szap and vlc are both compiled for old api. VLC is version 0.8.6h on 
Ubuntu 8.04 compiled by me. If I use latest hg drivers with KNC1 DVB-S 
card vlc is working without problems.

Can somebody help me find where the problem could be in vlc or 
multiproto drivers when vlc is accessing dvb card directly. Is there any 
event in drivers or VLC which is occurring every 10 seconds, that it 
could have some effect on card. Probably it should be something in the 
drivers, because VLC is working great with hg drivers and dvb-s card.

Thanks!

Best Regards,
Gregor


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
