Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1JQmRz-00057f-WF
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 17:33:12 +0100
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: "Albert Comerma" <albert.comerma@gmail.com>
Date: Sun, 17 Feb 2008 17:32:36 +0100
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802170414n6e4f82dam4c6908536b695033@mail.gmail.com>
	<ea4209750802170506o55b8b751u5c189f15bd140f44@mail.gmail.com>
In-Reply-To: <ea4209750802170506o55b8b751u5c189f15bd140f44@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802171732.36144.hfvogt@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
Reply-To: hfvogt@gmx.net
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

Albert,

I am happy to hear that your TV-card finally works.
However, I am still a bit unsure about these GPIO settings. Initially, I just copied the GPIO-settings from another entry and
then left it because it seemed to work. Now, I have digged a little bit into this issue and found, that under Windows my
STK7700PH-based stick gets the GPIO set in a different way.
Could you please try the following modified stk7700ph_frontend_attach routine (in dib0700_devices.c) and tell me
whether this works for your card as well?

static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
{
        dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
        msleep(20);
        dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
        dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
        dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
        dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
        msleep(10);
        dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
        msleep(20);
        dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
        msleep(10);

        dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18, &stk7700ph_dib7700_xc3028_config);

        adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
                                &stk7700ph_dib7700_xc3028_config);

        return adap->fe == NULL ? -ENODEV : 0;
}

By the way, I also experience the same problem with the missing SNR info, on two different dib0700-based USB cards.

Regards,
Hans-Frieder

Am Sonntag, 17. Februar 2008 schrieb Albert Comerma:
> I got it!!!! I remembered that on PCTV DVB-T 72e they had a similar problem,
> which was solved leaving GPIO6 to 0. Doing this the tuning seems to work
> fine. SNR is always reported as 0% but I think this is not a problem, now I
> can scan and tune dvb-t channels. Firmware is 1.10 and xc3028-v27 with that
> modification. Thanks a lot for your help. Next step would be analog.
> 
> Albert
> 



-- 
--
Hans-Frieder Vogt                 e-mail:  hfvogt <at> gmx .dot. net

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
