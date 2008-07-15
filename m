Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Arlott <simon@fire.lp0.eu>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <487D1964.7050607@simon.arlott.org.uk>
References: <4878F314.6090608@simon.arlott.org.uk>
	<1215919227.2662.3.camel@pc10.localdom.local>
	<487D1964.7050607@simon.arlott.org.uk>
Date: Wed, 16 Jul 2008 01:12:16 +0200
Message-Id: <1216163536.4290.17.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: v4l-dvb-maintainer@linuxtv.org, Linux DVB <linux-dvb@linuxtv.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] V4L: Link tuner before saa7134
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

Hi Simon,

Am Dienstag, den 15.07.2008, 22:40 +0100 schrieb Simon Arlott:
> If saa7134_init is run before v4l2_i2c_drv_init (tuner),
> then saa7134_board_init2 will try to set the tuner type
> for devices that don't exist yet. This moves tuner to
> before all of the device-specific drivers so that it's
> loaded early enough on boot.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> ---
> Resend... I accidentally left the git-send-email headers in.
> 
> Mailman appears to be easily confused too: 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027205.html

the saa713x maintainer after Gerd is actually Hartmut.

He might not have always the time for it immediately, but should have a
copy of what is going on.

Actually, these problems are within the build system and should not even
come down to a driver maintainer.

The crowd here is used to have some trouble concerning the build, best
was when guys like Trent did watch out for it before we had some impact.

Cheers,
Hermann

>  drivers/media/video/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index ecbbfaa..6b0af12 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -18,6 +18,8 @@ ifeq ($(CONFIG_VIDEO_V4L1_COMPAT),y)
>    obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
>  endif
>  
> +obj-$(CONFIG_VIDEO_TUNER) += tuner.o
> +
>  obj-$(CONFIG_VIDEO_BT848) += bt8xx/
>  obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>  obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
> @@ -84,8 +86,6 @@ obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
>  obj-$(CONFIG_VIDEO_DPC) += dpc7146.o
>  obj-$(CONFIG_TUNER_3036) += tuner-3036.o
>  
> -obj-$(CONFIG_VIDEO_TUNER) += tuner.o
> -
>  obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>  obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
>  obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
> -- 
> 1.5.6.2
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
