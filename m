Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 29 Aug 2008 12:02:13 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Finn Thain <fthain@telegraphics.com.au>
In-Reply-To: <Pine.LNX.4.64.0808291627340.21301@loopy.telegraphics.com.au>
Message-ID: <alpine.LRH.1.10.0808291157060.17297@pub3.ifh.de>
References: <Pine.LNX.4.64.0808291627340.21301@loopy.telegraphics.com.au>
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

Hi Finn,

Some comments below:

On Fri, 29 Aug 2008, Finn Thain wrote:
> 	.caps              = DVB_USB_IS_AN_I2C_ADAPTER, \
> 	.usb_ctrl          = DEVICE_SPECIFIC, \
> -	.firmware          = "dvb-usb-dib0700-1.10.fw", \
> +	.firmware          = "dvb-usb-dib0700-03-pre1.fw", \
> 	.download_firmware = dib0700_download_firmware, \

Why that? Have you tried the hardware with the dvb-usb-dib0700-1.10.fw? 
Does it not work?

Changing it at this place in the code is affect _all_ devices - this is 
not acceptable.

Please try the 1.10 firmware and send a new patch in case it is working.

Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
