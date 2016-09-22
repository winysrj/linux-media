Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48335 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753569AbcIVKHB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 06:07:01 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Bin Liu <b-liu@ti.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: g_webcam Isoch high bandwidth transfer
In-Reply-To: <87lgyknyp7.fsf@linux.intel.com>
References: <20160920170441.GA10705@uda0271908> <871t0d4r72.fsf@linux.intel.com> <20160921132702.GA18578@uda0271908> <87oa3go065.fsf@linux.intel.com> <87lgyknyp7.fsf@linux.intel.com>
Date: Thu, 22 Sep 2016 13:06:46 +0300
Message-ID: <87d1jw6yfd.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Felipe Balbi <felipe.balbi@linux.intel.com> writes:
> Felipe Balbi <felipe.balbi@linux.intel.com> writes:
>> Bin Liu <b-liu@ti.com> writes:
>>> On Wed, Sep 21, 2016 at 11:01:21AM +0300, Felipe Balbi wrote:
>>>>=20
>>>> Hi,
>>>>=20
>>>> Bin Liu <b-liu@ti.com> writes:
>>>> > Hi,
>>>> >
>>>> > I am trying to check Isoch high bandwidth transfer with g_webcam.ko =
in
>>>> >  high-speed connection.
>>>> >
>>>> > First I hacked webcam.c as follows to enable 640x480@30fps mode.
>>>> >
>>>> > diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget=
/legacy/webcam.c
>>>> > index 72c976b..9eb315f 100644
>>>> > --- a/drivers/usb/gadget/legacy/webcam.c
>>>> > +++ b/drivers/usb/gadget/legacy/webcam.c
>>>> > @@ -191,15 +191,15 @@ static const struct UVC_FRAME_UNCOMPRESSED(3) =
uvc_frame_yuv_360p =3D {
>>>> >         .bFrameIndex            =3D 1,
>>>> >         .bmCapabilities         =3D 0,
>>>> >         .wWidth                 =3D cpu_to_le16(640),
>>>> > -       .wHeight                =3D cpu_to_le16(360),
>>>> > +       .wHeight                =3D cpu_to_le16(480),
>>>> >         .dwMinBitRate           =3D cpu_to_le32(18432000),
>>>> >         .dwMaxBitRate           =3D cpu_to_le32(55296000),
>>>> > -       .dwMaxVideoFrameBufferSize      =3D cpu_to_le32(460800),
>>>> > -       .dwDefaultFrameInterval =3D cpu_to_le32(666666),
>>>> > +       .dwMaxVideoFrameBufferSize      =3D cpu_to_le32(614400),
>>>> > +       .dwDefaultFrameInterval =3D cpu_to_le32(333333),
>>>> >         .bFrameIntervalType     =3D 3,
>>>> > -       .dwFrameInterval[0]     =3D cpu_to_le32(666666),
>>>> > -       .dwFrameInterval[1]     =3D cpu_to_le32(1000000),
>>>> > -       .dwFrameInterval[2]     =3D cpu_to_le32(5000000),
>>>> > +       .dwFrameInterval[0]     =3D cpu_to_le32(333333),
>>>> > +       .dwFrameInterval[1]     =3D cpu_to_le32(666666),
>>>> > +       .dwFrameInterval[2]     =3D cpu_to_le32(1000000),
>>>> >  };
>>>> >
>>>> > then loaded g_webcam.ko as
>>>> >
>>>> > # modprobe g_webcam streaming_maxpacket=3D3072
>>>> >
>>>> > The endpoint descriptor showing on the host is
>>>> >
>>>> >       Endpoint Descriptor:
>>>> >         bLength                 7
>>>> >         bDescriptorType         5
>>>> >         bEndpointAddress     0x8d  EP 13 IN
>>>> >         bmAttributes            5
>>>> >           Transfer Type            Isochronous
>>>> >           Synch Type               Asynchronous
>>>> >           Usage Type               Data
>>>> >         wMaxPacketSize     0x1400  3x 1024 bytes
>>>> >         bInterval               1
>>>> >
>>>> > However the usb bus trace shows only one transaction with 1024-bytes=
 packet in
>>>> > every SOF. The host only sends one IN packet in every SOF, I am expe=
cting 2~3
>>>> > 1024-bytes transactions, since this would be required to transfer 64=
0x480@30fps
>>>> > YUV frames in high-speed.
>>>> >
>>>> > DId I miss anything in the setup?
>>>>=20
>>>> MUSB or DWC3? This looks like a UDC bug to me. Can you show a screensh=
ot
>>>
>>> Happened on both MUSB and DWC3.
>>>
>>>> of your bus analyzer? When host sends IN token, are you replying with
>>>
>>> The trace screenshot on DWC3 is attached.
>>>
>>>> DATA0, DATA1 or DATA2?
>>>
>>> Good hint! It is DATA0!
>>
>> yeah, should've been DATA2. I'll check if we're missing anything for
>> High Bandwidth Iso on DWC3. Can you confirm if it works of tails on
>> DWC3? On your follow-up mail you mentioned it's a bug in MUSB. What
>> about DWC3?
>
> I'm assuming DWC3 really breaks. Here's a patch for that:
>
> 8<---------------------------------- cut here ---------------------------=
-------
> From 62807011c00055785575bb39d92bfe8836817e2f Mon Sep 17 00:00:00 2001
> From: Felipe Balbi <felipe.balbi@linux.intel.com>
> Date: Thu, 22 Sep 2016 11:01:01 +0300
> Subject: [PATCH] usb: dwc3: gadget: set PCM1 field of isochronous-first T=
RBs
>
> In case of High-Speed, High-Bandwidth endpoints, we
> need to tell DWC3 that we have more than one packet
> per interval. We do that by setting PCM1 field of
> Isochronous-First TRB.
>
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---
>  drivers/usb/dwc3/gadget.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 602f12254161..106623faf060 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -787,6 +787,9 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
>  		unsigned length, unsigned chain, unsigned node)
>  {
>  	struct dwc3_trb		*trb;
> +	struct dwc3		*dwc =3D dep->dwc;
> +	struct usb_gadget	*gadget =3D &dwc->gadget;
> +	enum usb_device_speed	speed =3D speed;

and of course I sent the wrong version :-)

Here's one that actually compiles, sorry about that.

8<---------------------------------- cut here -----------------------------=
-----
From=2044282f6c664b17e6b9dffbc31e72258be84823a4 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@linux.intel.com>
Date: Thu, 22 Sep 2016 11:01:01 +0300
Subject: [PATCH] usb: dwc3: gadget: set PCM1 field of isochronous-first TRBs

In case of High-Speed, High-Bandwidth endpoints, we
need to tell DWC3 that we have more than one packet
per interval. We do that by setting PCM1 field of
Isochronous-First TRB.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
=2D--
 drivers/usb/dwc3/gadget.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 602f12254161..34a7b1bf0522 100644
=2D-- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -787,6 +787,9 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 		unsigned length, unsigned chain, unsigned node)
 {
 	struct dwc3_trb		*trb;
+	struct dwc3		*dwc =3D dep->dwc;
+	struct usb_gadget	*gadget =3D &dwc->gadget;
+	enum usb_device_speed	speed =3D gadget->speed;
=20
 	dwc3_trace(trace_dwc3_gadget, "%s: req %p dma %08llx length %d%s",
 			dep->name, req, (unsigned long long) dma,
@@ -813,10 +816,17 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 		break;
=20
 	case USB_ENDPOINT_XFER_ISOC:
=2D		if (!node)
+		if (!node) {
 			trb->ctrl =3D DWC3_TRBCTL_ISOCHRONOUS_FIRST;
=2D		else
+
+			if (speed =3D=3D USB_SPEED_HIGH) {
+				struct usb_ep *ep =3D &dep->endpoint;
+				u8 pkts =3D DIV_ROUND_UP(ep->maxpacket, 1024);
+				trb->size |=3D DWC3_TRB_SIZE_PCM1(pkts - 1);
+			}
+		} else {
 			trb->ctrl =3D DWC3_TRBCTL_ISOCHRONOUS;
+		}
=20
 		/* always enable Interrupt on Missed ISOC */
 		trb->ctrl |=3D DWC3_TRB_CTRL_ISP_IMI;
=2D-=20
2.10.0



=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX4602AAoJEMy+uJnhGpkGJIwP/A4FE5QFRxIbI+zZLOMDplx/
Mrn/wi3iHGiNTXJLsY3haa9A0onfa2BvoMT3y0wFZFYHG/QaG4ldklbRJNdLOmB9
rPvJUGyO/avpwg/RCVGsG7hUuKZzt7kDI2ioUyI1ydX7i+nGgup4XAppf4DcNjjB
eDQYewbjQhZG/VvTZpr+/R4OUH5UcTY8FMBg0HTiI/yc64LKnfSy1nPs9paFVfP7
iC6DbF3uRZVJJoAqpDxqXwB2HsZdhkG1XoPjeJ6QrYodhP7QAzTCrvqRnNLd423e
eyYgy21K3TEwKEcHSHfj2nMWS116wqxsdLBgjQ5ol203bEDE3nJxoWoBBQNmT6kE
y6by/SBnCkneAwnQLj0gPzZ6Hpoc2at4eMLv0VWo7IKdVzY+Hpji7Bb4mPnEmhsI
QwNWAM8DYE6jWgRjcfC7NaaaSgDShNZ06fomqkYHNHfTko/T8rbDU4STQaxBgYq+
ruR1wlhqrjQE9xwybT6TBpdNe7Jei9aBLhjDhCgBhGFiV511Ac3uEmWIY3uf31VQ
vSN7gyXzWz7v7ZEi8V/2fA1Oc6yejPAepxAEDYgH358ga01pilP6ODBUFny2YJFL
edrn2PRdSS909bvUuKty1zr7gTfeH614kL55kjGhEkAocripfL8JH+uQAZizJA3M
E6v/3xUwXITk6ZegsW3+
=cq7c
-----END PGP SIGNATURE-----
--=-=-=--
