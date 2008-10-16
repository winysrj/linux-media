Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KqUVr-0002si-As
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 17:11:46 +0200
Received: by gv-out-0910.google.com with SMTP id n29so25052gve.16
	for <linux-dvb@linuxtv.org>; Thu, 16 Oct 2008 08:11:39 -0700 (PDT)
Message-ID: <37219a840810160811s2c2eff4cve7ac47f93de2eb0c@mail.gmail.com>
Date: Thu, 16 Oct 2008 11:11:39 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mark Kimsal" <mark@metrofindings.com>
In-Reply-To: <200810160925.51556.mark@metrofindings.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <200810160925.51556.mark@metrofindings.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add syntek corp device to au0828
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

On Thu, Oct 16, 2008 at 9:25 AM, Mark Kimsal <mark@metrofindings.com> wrote:
> The woodbury is the first model I chose, and it seems to work.  I tried two
> others and they do not tune any channels, although the module au0828 does
> load.  Watching ATSC works fine, haven't tried NTSC or QAM.
>
> diff -r 9273407ca6e1 linux/drivers/media/video/au0828/au0828-cards.c
> --- a/linux/drivers/media/video/au0828/au0828-cards.c   Wed Oct 15 02:50:03
> 2008 +0400
> +++ b/linux/drivers/media/video/au0828/au0828-cards.c   Thu Oct 16 09:23:50
> 2008 -0400
> @@ -212,6 +212,8 @@ struct usb_device_id au0828_usb_id_table
>                .driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
>        { USB_DEVICE(0x2040, 0x8200),
>                .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
> +       { USB_DEVICE(0x05e1, 0x0400),
> +               .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
>        { },
>  };

Mark,

I thought this stick had an MT2130 inside -- looks like you've got
another revision with a TDA18271... very interesting :-)

You say that ATSC works -- does it work on more than just one channel?
 If ATSC works, then QAM should work as well.  NTSC is not yet
supported in the Linux driver.

Can you show me the dmesg output when the driver loads?  Also, can you
give me the exact name of the device (from the retail package) ?

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
