Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:51150 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbdIVSEu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 14:04:50 -0400
From: Eric Anholt <eric@anholt.net>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-rpi-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/4] [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
In-Reply-To: <CAAoAYcMFm82vo5k-iCCpARbndyrLDt1UMV_kRUDHiHA0iMzhMg@mail.gmail.com>
References: <cover.1505916622.git.dave.stevenson@raspberrypi.org> <fae3d29bba67825030c0077dd9c79534b6888512.1505916622.git.dave.stevenson@raspberrypi.org> <1814950930.414004.1506062733728@email.1und1.de> <CAAoAYcMFm82vo5k-iCCpARbndyrLDt1UMV_kRUDHiHA0iMzhMg@mail.gmail.com>
Date: Fri, 22 Sep 2017 11:04:46 -0700
Message-ID: <877ewqd2yp.fsf@anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Dave Stevenson <dave.stevenson@raspberrypi.org> writes:

> Hi Stefan
>
> On 22 September 2017 at 07:45, Stefan Wahren <stefan.wahren@i2se.com> wrote:
>> Hi Dave,
>>
>>> Dave Stevenson <dave.stevenson@raspberrypi.org> hat am 20. September 2017 um 18:07 geschrieben:
>>>
>>>
>>> Document the DT bindings for the CSI2/CCP2 receiver peripheral
>>> (known as Unicam) on BCM283x SoCs.
>>>
>>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>>> ---
>>>
>>> Changes since v2
>>> - Removed all references to Linux drivers.
>>> - Reworded section about disabling the firmware driver.
>>> - Renamed clock from "lp_clock" to "lp" in description and example.
>>> - Referred to video-interfaces.txt and stated requirements on remote-endpoint
>>>   and data-lanes.
>>> - Corrected typo in example from csi to csi1.
>>> - Removed unnecessary #address-cells and #size-cells in example.
>>> - Removed setting of status from the example.
>>>
>>>  .../devicetree/bindings/media/bcm2835-unicam.txt   | 85 ++++++++++++++++++++++
>>>  1 file changed, 85 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/bcm2835-unicam.txt b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>>> new file mode 100644
>>> index 0000000..7714fb3
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>>> @@ -0,0 +1,85 @@
>>> +Broadcom BCM283x Camera Interface (Unicam)
>>> +------------------------------------------
>>> +
>>> +The Unicam block on BCM283x SoCs is the receiver for either
>>> +CSI-2 or CCP2 data from image sensors or similar devices.
>>> +
>>> +The main platform using this SoC is the Raspberry Pi family of boards.
>>> +On the Pi the VideoCore firmware can also control this hardware block,
>>> +and driving it from two different processors will cause issues.
>>> +To avoid this, the firmware checks the device tree configuration
>>> +during boot. If it finds device tree nodes called csi0 or csi1 then
>>> +it will stop the firmware accessing the block, and it can then
>>> +safely be used via the device tree binding.
>>> +
>>> +Required properties:
>>> +===================
>>> +- compatible : must be "brcm,bcm2835-unicam".
>>> +- reg                : physical base address and length of the register sets for the
>>> +               device.
>>> +- interrupts : should contain the IRQ line for this Unicam instance.
>>> +- clocks     : list of clock specifiers, corresponding to entries in
>>> +               clock-names property.
>>> +- clock-names        : must contain an "lp" entry, matching entries in the
>>> +               clocks property.
>>> +
>>> +Unicam supports a single port node. It should contain one 'port' child node
>>> +with child 'endpoint' node. Please refer to the bindings defined in
>>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>>> +
>>> +Within the endpoint node the "remote-endpoint" and "data-lanes" properties
>>> +are mandatory.
>>> +Data lane reordering is not supported so the data lanes must be in order,
>>> +starting at 1. The number of data lanes should represent the number of
>>> +usable lanes for the hardware block. That may be limited by either the SoC or
>>> +how the platform presents the interface, and the lower value must be used.
>>> +
>>> +Lane reordering is not supported on the clock lane either, so the optional
>>> +property "clock-lane" will implicitly be <0>.
>>> +Similarly lane inversion is not supported, therefore "lane-polarities" will
>>> +implicitly be <0 0 0 0 0>.
>>> +Neither of these values will be checked.
>>> +
>>> +Example:
>>> +     csi1: csi1@7e801000 {
>>> +             compatible = "brcm,bcm2835-unicam";
>>> +             reg = <0x7e801000 0x800>,
>>> +                   <0x7e802004 0x4>;
>>
>> sorry, i didn't noticed this before. I'm afraid this is using a small range of the CMI. Are there possible other users of this range? Does it make sense to handle this by a separate clock driver?
>
> CMI (Clock Manager Image) consists of a total of 4 registers.
> 0x7e802000 is CMI_CAM0, with only bits 0-5 used for gating and
> inversion of the clock and data lanes (2 data lanes available on
> CAM0).
> 0x7e802004 is CMI_CAM1, with only bits 0-9 used for gating and
> inversion of the clock and data lanes (4 data lanes available on
> CAM1).
> 0x7e802008 is CMI_CAMTEST which I have no documentation or drivers for.
> 0x7e802010 is CMI_USBCTL. Only bit 6 is documented and is a reset. The
> default value is the required value. Nothing touches it that I can
> find.

Yeah, my conclusion previously was that it's appropriate to consider
this register as part of the unicam instance.  No other HW block could
want to talk to it.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlnFUL8ACgkQtdYpNtH8
nujHug//cIvAfg5NGU41AGlwItA8yaj1GTwOqiQn4LE7g6u/N8yVG7AVoCmoWLLe
2c6sbCD/aLGGlOJ6AfhpG9v4ZW8Mi38SGLC5z/q1UR0Sa5J+UtjLqppLUdy6Dh+g
EW8DnP1MqZuVd1FGnx+hFc0bycwdgD9ihngZfeHJz1MEjjUvDjEXgagvE7SEiqKb
nTbtKijtbVQFsj2Gv5HvUrOxrlmYMEG7eDIyKEE/cuAKA1cm9qipCOyRXKngvGi8
1hMRbUanBq+H2uoYDTsVy16DZrQJHadkPgbaeZsTmN0RoOA2XA5kroL6Z8iH47Ba
J5VyaX3VYVkUMd9AS6PHs5N4FsG/3X/G8s0uIBqNj4L0k6UkBwE9zwDbT3H/StGt
1S34WTvbEm+vpUHmsxLLE7EAxAvmNnRioHUqXtxHgfOHekegwGcSSnhwYz6fJwmN
zLT2+Z8Uhlm5GBBbW2ZIdA3XvEWU5ODMJfl56nMbmulhT7srTj9LLS4JuoBkkqe/
xYntIxkneNSITt3Ku2ZvMsuPnNnD5wZ9yOTFUUOpMu8KLbqHYm6u4Ul8t0hLT/dl
mZZcJEgtADZ1Tnrt0WlW7eRWJcL1f/EaqCmG7bPI1MSU/cHdhaZjxozmSDZuFtVD
LI6m13Qo7i1vhBsRWPdeeXbYeQqSH9nYgJvtYGx2845yrBBYlyM=
=uk2T
-----END PGP SIGNATURE-----
--=-=-=--
