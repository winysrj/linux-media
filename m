Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 29 Aug 2008 21:46:13 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0808291157060.17297@pub3.ifh.de>
Message-ID: <Pine.LNX.4.64.0808292129330.21301@loopy.telegraphics.com.au>
References: <Pine.LNX.4.64.0808291627340.21301@loopy.telegraphics.com.au>
	<alpine.LRH.1.10.0808291157060.17297@pub3.ifh.de>
MIME-Version: 1.0
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add support for the Gigabyte R8000-HT USB
 DVB-T adapter
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



On Fri, 29 Aug 2008, Patrick Boettcher wrote:

> Hi Finn,
> 
> Some comments below:
> 
> On Fri, 29 Aug 2008, Finn Thain wrote:
> >  .caps              = DVB_USB_IS_AN_I2C_ADAPTER, \
> >  .usb_ctrl          = DEVICE_SPECIFIC, \
> > -	.firmware          = "dvb-usb-dib0700-1.10.fw", \
> > +	.firmware          = "dvb-usb-dib0700-03-pre1.fw", \
> >  .download_firmware = dib0700_download_firmware, \
> 
> Why that? Have you tried the hardware with the dvb-usb-dib0700-1.10.fw? 
> Does it not work?

Not sure. My test with that firmware was inconclusive, and then I found 
Ilia's post, which implied that it wouldn't work anyway. I need to test it 
again now that everything else works.

> Changing it at this place in the code is affect _all_ devices - this is 
> not acceptable.
> 
> Please try the 1.10 firmware and send a new patch in case it is working.

There are a some links to that file in google. But renaming firmware files 
seems to be common.

Can you send me a firmware file to test, or the md5sum of the accepted 
firmware? The linux/Documentation/dvb/get_dvb_firmware yields a file 
called dvb-dibusb-5.0.0.11.fw but I guess that's not it.

Thanks,
Finn



> 
> Patrick.
> 
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
