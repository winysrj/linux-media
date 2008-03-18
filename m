Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+b9c06d2e3da2f0ede24a+1668+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JbjMp-0005EZ-TN
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 22:29:08 +0100
Date: Tue, 18 Mar 2008 18:28:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: gian luca rasponi <lucarasp@inwind.it>
Message-ID: <20080318182810.0189de8e@gaivota>
In-Reply-To: <47E030C1.2000805@inwind.it>
References: <47E030C1.2000805@inwind.it>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
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

On Tue, 18 Mar 2008 22:14:41 +0100
gian luca rasponi <lucarasp@inwind.it> wrote:

> hi,
> 
> more or less same here:
> 
> I've built and installed latest v4l-dvb-3029b981e42c modified with IR 
> remote support, and loaded with:
> 
> /etc/modprobe.d/saa7134:
> 
> options saa7134 tuner=71 ir_debug=1
> install saa7134 /sbin/modprobe xc3028-tuner; /sbin/modprobe 
> --ignore-install saa7134; /sbin/modprobe saa7134-dvb; /sbin/modprobe 
> saa7134-alsa
> 
> then:
> 
> modprobe saa7134 tuner=71 i2c_scan=1

Please test without tuner=71. I've just updated the tree again. It should detect it well right now. 

Please add this to your modprobe.conf:
	options tuner debug=1
	options tuner-xc2028 debug=1

This will enable some extra debugs for tuner. You'll need to remove all modules
before probing again. A good procedure for tests is:

	make rmmod
	make
	make install
	modprobe saa7124 i2c_scan=1

(sometimes, I also do a "make rminstall" to remove .gz modules that some distro
uses, when I compile against a non-mainstream kernel)

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
