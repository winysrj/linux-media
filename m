Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp130.rog.mail.re2.yahoo.com ([206.190.53.35])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1LM7ji-00023l-MP
	for linux-dvb@linuxtv.org; Sun, 11 Jan 2009 22:20:48 +0100
Message-ID: <496A628B.1010805@rogers.com>
Date: Sun, 11 Jan 2009 16:20:11 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Pierre-Jean BELIN <pjb.belin@gmail.com>
References: <c54d87990901091235k1a1736dfka0bda9d720f2667@mail.gmail.com>
In-Reply-To: <c54d87990901091235k1a1736dfka0bda9d720f2667@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Post:/dev directory not populated while trying to
 use a	Cinergy DT USB XS Diversity USB TV tuner
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

Pierre-Jean BELIN wrote:
> Hello
>
> I am trying to use a TerraTec Cinergy DT USB XS Diversity USB key to
> broadcast video on my private network.
>
> I have followed tutorials from www.linuxtv.org but impossible to start
> the device.
>
> The key works correctly on Vista, so I am sure that the device is not
> out of order.
>
> My OS is a Fedora Sulfur ; kernel version : 2.6.27.9-73.fc9; my box is a 64bits
>
> 1) I describe hereunder all the steps I followed to (unsuccessfully)
> start the key.
>
> Everything is based on www.linuxtv.org tutos.
>
> a) Installation of Mercurial and download of all the sources to
> compile the modules.
> b) As mentioned in the description of the key
> (http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity#Firmware)
> my device id is 0081 instead of 005a. Thus, I have modified (only
> replace 005a by 0081) the file
> linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h to take into account
> this change.
>
> Old line
> ==================================================================
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY        0x005a
> ==================================================================
> New line
> ==================================================================
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY        0x0081
> ==================================================================
Pierre,

It requires a little bit more more changes to the source code. See
Nicolas' patch, which he resubmitted (and hopefully gets picked up this
time) a few hours after your message:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg00138.html



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
