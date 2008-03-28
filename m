Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+711736df28a10b9df8a2+1678+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JfIs1-0002S5-Fc
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 19:00:05 +0100
Date: Fri, 28 Mar 2008 14:59:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080328145927.145b1a62@gaivota>
In-Reply-To: <1206683274.5986.6.camel@ubuntu>
References: <1206635698.5965.5.camel@ubuntu> <20080327144221.2d642590@gaivota>
	<1206683274.5986.6.camel@ubuntu>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

On Fri, 28 Mar 2008 14:47:54 +0900
timf <timf@iinet.net.au> wrote:

> Hi Mauro,
> 
> I just had to quickly tell you that I built it with this, rebooted, clicked
> on tvtime, and waited anxiously watching a black screen - then WAHOO!
> A TV program I am viewing!!
Great!

I've committed the patch with what we currently have. Please test if analog
keeps working with the patch.

Now, it is time to work with the demod side.

Please, change the #if 0 to #if 1:
#if 0
                /* Not working yet */
                .mpeg           = SAA7134_MPEG_DVB,
#endif

And test to see if analog still works fine. If ok, please test the digital side.

You may need to figure out the proper parameters for mt352, on this part of the
code(at saa7134-dvb):

static int mt352_aver_a16d_init(struct dvb_frontend *fe)
{
        static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x2d };
        static u8 reset []         = { RESET,      0x80 };
        static u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
        static u8 agc_cfg []       = { AGC_TARGET, 0x28, 0xa0 };
        static u8 capt_range_cfg[] = { CAPT_RANGE, 0x33 };

        mt352_write(fe, clock_config,   sizeof(clock_config));
        udelay(200);
        mt352_write(fe, reset,          sizeof(reset));
        mt352_write(fe, adc_ctl_1_cfg,  sizeof(adc_ctl_1_cfg));
        mt352_write(fe, agc_cfg,        sizeof(agc_cfg));
        mt352_write(fe, capt_range_cfg, sizeof(capt_range_cfg));

        return 0;
}

You may need to try to change the above code, trying other existing mt352 code,
or using some tool to get the initialization code done by your windows driver.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
