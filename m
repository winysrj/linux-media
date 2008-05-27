Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+4f9853696f040eae3e7e+1738+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1K14UJ-0006wq-C8
	for linux-dvb@linuxtv.org; Tue, 27 May 2008 21:05:35 +0200
Date: Tue, 27 May 2008 16:05:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Albert Comerma" <albert.comerma@gmail.com>
Message-ID: <20080527160509.723fa149@gaivota>
In-Reply-To: <ea4209750805270823h357384fcmfa981d2244472dae@mail.gmail.com>
References: <483C2458.4080004@pandora.be>
	<ea4209750805270823h357384fcmfa981d2244472dae@mail.gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem initialising Terratec Cinergy HT USB XE
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

Hi Albert,

On Tue, 27 May 2008 17:23:50 +0200
"Albert Comerma" <albert.comerma@gmail.com> wrote:

> There seems to be a problem with the last changes on xc2028 code, please try
> this;
> 
> In linux/drivers/media/common/tuners/tuner-xc2028.c file, on xc2028_attach,
> video_dev must be = cfg->video_dev;
> and on the current source it's = cfg->i2c_adap->algo_data; which completely
> breaks the module when loaded.
> 
> It was already suggested that this should be changed, but nobody said why
> this modification was done or why it was kept.
> 
> Mauro could you trace when and why this modification was done? or at least
> give it back to original state?
> 

It seems that I forgot to merge the fix for this. I've just committed it. Could
you please test ? It is already available at mercurial tree.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
