Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.233])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mimic0310@gmail.com>) id 1JeM3G-0003Dm-3P
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 04:11:47 +0100
Received: by wr-out-0506.google.com with SMTP id c30so2725433wra.14
	for <linux-dvb@linuxtv.org>; Tue, 25 Mar 2008 20:11:41 -0700 (PDT)
Message-ID: <c92beebe0803252011g6ac0a020jcfbbb429d78bdc4c@mail.gmail.com>
Date: Wed, 26 Mar 2008 11:11:40 +0800
From: "Cheng-Min Lien" <mimic0310@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Any chance of help with v4l-dvb-experimental /
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

sorry for the wrong subject.

On Wed, Mar 26, 2008 at 11:02 AM, Cheng-Min Lien <mimic0310@gmail.com> wrote:
> Hi all,
>
>  After using Mauro's patch, I try to set the gpio pin in function
>  "saa7134_xc2028_callback".
>  Now, I can watch analog TV.
>  The  GPIO pin 21 seems the reset pin for tuner.
>  The mt352 demod is still no response....
>
>  ===========================================================
>  static int saa7134_xc2028_callback(struct saa7134_dev *dev,
>                    int command, int arg)
>  {
>
>     switch (command) {
>     case XC2028_TUNER_RESET:
>         saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
>         saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);
>         saa_andorl(SAA7133_ANALOG_IO_SELECT >> 2, 0x02, 0x02);
>         saa_andorl(SAA7134_ANALOG_IN_CTRL1 >> 2, 0x81, 0x81);
>         saa_andorl(SAA7134_AUDIO_CLOCK0 >> 2, 0x03187de7, 0x03187de7);
>         saa_andorl(SAA7134_AUDIO_PLL_CTRL >> 2, 0x03, 0x03);
>         saa_andorl(SAA7134_AUDIO_CLOCKS_PER_FIELD0 >> 2,
>                0x0001e000, 0x0001e000);
>
>         #if 1
>         saa7134_set_gpio(dev, 21, 0);
>         msleep(20);
>         saa7134_set_gpio(dev, 21, 1);
>         #endif
>
>         return 0;
>     }
>     return -EINVAL;
>  }
>  ====================================================================
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
