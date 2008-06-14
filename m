Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hu-out-0506.google.com ([72.14.214.233])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artlov@gmail.com>) id 1K7dvP-0004Ec-SR
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 00:08:46 +0200
Received: by hu-out-0506.google.com with SMTP id 23so6445409huc.11
	for <linux-dvb@linuxtv.org>; Sat, 14 Jun 2008 15:08:27 -0700 (PDT)
Message-ID: <48544159.8080706@gmail.com>
Date: Sun, 15 Jun 2008 01:08:25 +0300
From: Arthur Konovalov <artlov@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1212585271.32385.41.camel@pascal>	<1212590233.15236.11.camel@rommel.snap.tv>	<1212657011.32385.53.camel@pascal><200806081738.20609@orion.escape-edv.de>	<484CBDF3.90806@gmail.com>
	<09e001c8ce5a$558b9a50$7501010a@ad.sytec.com>
In-Reply-To: <09e001c8ce5a$558b9a50$7501010a@ad.sytec.com>
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

Simon Baxter wrote:
> Hi
> 
> What am I doing wrong - sorry for the potentially idiot error...
> 
> I got what I thought was the latest, which would include these c-1501 
> patches yes??
> hg clone http://linuxtv.org/hg/v4l-dvb
> 
> 
> But there's no "linux/drivers/media/dvb/frontends/tda827x.c"   and the 
> "linux/drivers/media/dvb/ttpci/budget-ci.c"   is not the same as the patches 
> references.
> 
> [root@freddy v4l-dvb]# find . | grep tda827x.c
> ./.hg/store/data/linux/drivers/media/common/tuners/tda827x.c.i
> ./.hg/store/data/linux/drivers/media/dvb/frontends/tda827x.c.i
> ./linux/drivers/media/common/tuners/tda827x.c
> 
> 
> Have I got the wrong repository??
> 
Mentioned patches adopted to multiproto tree. For v4l-dvb please use 
Sigmund's original patches if these not committed yet.

Regards,
AK


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
