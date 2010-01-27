Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:52457 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab0A0QhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 11:37:16 -0500
Received: by ywh36 with SMTP id 36so57560ywh.15
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 08:37:15 -0800 (PST)
Date: Wed, 27 Jan 2010 14:37:09 -0200
From: Nicolau Werneck <nwerneck@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Setting up white balance on a t613 camera
Message-ID: <20100127163709.GA10435@pathfinder.pcs.usp.br>
References: <20100126170053.GA5995@pathfinder.pcs.usp.br> <20100126193726.00bcbc00@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100126193726.00bcbc00@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again, people. I believe I have found in my log the commands
that are setting up that white balance parameters. I am pasting an
excerpt of the log at the end. (I changed the subject now that is
seems this is actually the way I should follow)

It looks to me that in that SetupPacket vector the "88" encodes what
channel to set. 87 for red, 88 for blue and 89 for green. The
following value is the level, which is default to 0x20. 

The question now is how do I offer to set up that parameter in the
driver? What function can I use to transmits a vector that way, so I
can make a hacky test?

In other words: would it be possible or me to just cut and paste some
code in the driver to implement that? Or will I be finally forced to
actually learn what I am doing? :)

regards,

   ++nicolau


(...)
[61857 ms]  <<<  URB 393 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 89fecb10
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
  USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000000
  TransferBuffer       = 00000000
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 88 1c 00 00
[61910 ms] UsbSnoop - DispatchAny(bac00610) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[61910 ms] UsbSnoop - MyDispatchInternalIOCTL(bac01e80) :
fdo=89cf58b0, Irp=89473e48, IRQL=0
[61910 ms]  >>>  URB 394 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
  ~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000000
  TransferBuffer       = 00000000
  TransferBufferMDL    = 00000000

    no data supplied
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00001e88
[61913 ms] UsbSnoop - MyInternalIOCTLCompletion(bac01db0) :
  fido=00000000, Irp=89473e48, Context=898d8fe8, IRQL=2
[61913 ms]  <<<  URB 394 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 89fecb10
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
  USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000000
  TransferBuffer       = 00000000
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 88 1e 00 00
[61950 ms] UsbSnoop - DispatchAny(bac00610) :
  IRP_MJ_INTERNAL_DEVICE_CONTROL
[61950 ms] UsbSnoop - MyDispatchInternalIOCTL(bac01e80) :
  fdo=89cf58b0, Irp=89f97008, IRQL=0
[61950 ms]  >>>  URB 395 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
  ~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000000
  TransferBuffer       = 00000000
  TransferBufferMDL    = 00000000

    no data supplied
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00002088
(...)




On Tue, Jan 26, 2010 at 07:37:26PM +0100, Jean-Francois Moine wrote:
> On Tue, 26 Jan 2010 15:00:53 -0200
> Nicolau Werneck <nwerneck@gmail.com> wrote:
> 
> > Hello. I have this very cheap webcam that I sent a patch to support on
> > gspca the other day. The specific driver is the t613.
> > 
> > I changed the lens of this camera, and now my images are all too
> > bright, what I believe is due to the much larger aperture of this new
> > lens. So I would like to try setting up a smaller exposure time on the
> > camera (I would like to do that for other reasons too).
> > 
> > The problem is there's no "exposure" option to be set when I call
> > programs such as v4lctl. Does that mean there is definitely no way for
> > me to control the exposure time? The hardware itself was not designed
> > to allow me do that? Or is there still a chance I can create some C
> > program that might do it, for example?
> 	[snip]
> 
> Hello Nicolau,
> 
> There are brightness, contrast, colors, autogain and some other video
> controls for the t613 webcams. You must use a v4l2 compliant program to
> change them, as vlc or v4l2ucp (but not cheese).
> 
> Regards.
> 
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
Linux user #460716

