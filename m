Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
MIME-version: 1.0
Date: Fri, 11 Apr 2008 09:15:48 -0500 (CDT)
From: Jernej Tonejc <tonejc@math.wisc.edu>
In-reply-to: <47FF69D7.5070209@linuxtv.org>
To: Steven Toth <stoth@linuxtv.org>
Message-id: <Pine.LNX.4.64.0804110900070.3892@garbadale.math.wisc.edu>
References: <Pine.LNX.4.64.0804102256540.3892@garbadale.math.wisc.edu>
	<ea4209750804110226u18388307m48c629fe69b20d99@mail.gmail.com>
	<47FF69D7.5070209@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV HD pro USB stick 801e
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

>>
>>     DIBcom 0700C-XCCXa-G
>>     USB 2.0 D3LTK.1
>>     0804-0100-C
>>     -----------------
>
> Hmm. I haven't really used the dibcom src but I think this is already 
> supported.
Yes, this part works (I think this is responsible for attaching the IR 
remote controler and the remote works).

>
>>     SAMSUNG
>>     S5H1411X01-Y0
>>     NOTKRSUI H0801
>
> I have a driver for this, I hope to release it shortly.

I think this is the main problem for me so far. Without a frontend 
attached it doesn't try to attach the tuner and the code for s5h1409 just 
doesn't find the demod at any address (I tried everything from 0x00-0x7F 
on i2c bus). For some reason the i2c bus on the device doesn't seem to 
support anything, here's the output of  i2cdetect -F 4
(i2c-4       i2c             Pinnacle USB HDTV pro 801e)
I2C                              yes
SMBus Quick Command              no
SMBus Send Byte                  no
SMBus Receive Byte               no
SMBus Write Byte                 no
SMBus Read Byte                  no
SMBus Write Word                 no
SMBus Read Word                  no
SMBus Process Call               no
SMBus Block Write                no
SMBus Block Read                 no
SMBus Block Process Call         no
SMBus PEC                        no
I2C Block Write                  no
I2C Block Read                   no

>>     -----------------
>>     XCeive
>>     XC5000AQ
>>     BK66326.1
>>     0802MYE3
>>     -----------------
>
> I did a driver for this, it's already in the kernel.
I know, I added the code to attach this tuner but as I said before, it 
doesn't even try if there's no frontend.

> Why not get involved and scratch your own itch? :)
>
> The community could use more developers, why not roll up your sleeves and 
> help solve your problem - and the problem for others? Everyone has to start 
> somewhere and usually when would-be developers ask questions - everyone is 
> willing to help.

I'll try to do my best - the problem is that I don't know where to begin
and which parts are needed for the thing to work. It seems to me that 
getting the code for s5h1411 would be the start since the dib0700 part 
does work up to attaching the frontend. The /dev/dvb/adapter0/ folder 
contains:
crw-rw---- 1 root video 212, 4 2008-04-11 09:02 demux0
crw-rw---- 1 root video 212, 5 2008-04-11 09:02 dvr0
crw-rw---- 1 root video 212, 7 2008-04-11 09:02 net0


I think the s5h1409 code is just not compatible with s5h1411. Also, the 
GPIO settings are currently just copied from some other frontend attaching 
function (stk7070pd_frontend_attach0):

static int s5h1411_frontend_attach(struct dvb_usb_adapter *adap)
{
         dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
         msleep(10);
         dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
         dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
         dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
         dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);

         dib0700_ctrl_clock(adap->dev, 72, 1);

         msleep(10);
         dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
         msleep(10);
         dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);

         /*dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
                 &dib7070p_dib7000p_config); */

         adap->fe = dvb_attach(s5h1409_attach, &pinnacle_801e_config,
                         &adap->dev->i2c_adap );
         return adap->fe == NULL ? -ENODEV : 0;
}

I have NO idea what should be set to what values. Also, what is the 
equivalent of dib7000p_i2c_enumeration for s5h14xx family? (it's commented 
out in the above code as it does not work.
Also, I have no previous experience with DVB stuff so I really don't know 
which parts are independent from each other and how to test various things 
on the device.

Regards,
  Jernej


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
