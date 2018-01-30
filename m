Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:55648 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753430AbeA3Tdf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 14:33:35 -0500
Subject: Re: [PATCH 2/9] em28xx: Bulk transfer implementation fix
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Brad Love <brad@nextdimension.cc>
Cc: linux-media@vger.kernel.org
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
 <1515110659-20145-3-git-send-email-brad@nextdimension.cc>
 <20180130100750.06487d7a@vela.lan>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <dd76929e-3d3e-d1da-c37e-9f370f32e020@nextdimension.cc>
Date: Tue, 30 Jan 2018 13:33:34 -0600
MIME-Version: 1.0
In-Reply-To: <20180130100750.06487d7a@vela.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2018-01-30 06:07, Mauro Carvalho Chehab wrote:
> Em Thu,  4 Jan 2018 18:04:12 -0600
> Brad Love <brad@nextdimension.cc> escreveu:
>
>> Set appropriate bulk/ISOC transfer multiplier on capture start.
>> This sets ISOC transfer to 940 bytes (188 * 5)
>> This sets bulk transfer to 48128 bytes (188 * 256)
>>
>> The above values are maximum allowed according to Empia.
>>
>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>> ---
>>  drivers/media/usb/em28xx/em28xx-core.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/us=
b/em28xx/em28xx-core.c
>> index ef38e56..67ed6a3 100644
>> --- a/drivers/media/usb/em28xx/em28xx-core.c
>> +++ b/drivers/media/usb/em28xx/em28xx-core.c
>> @@ -638,6 +638,18 @@ int em28xx_capture_start(struct em28xx *dev, int =
start)
>>  	    dev->chip_id =3D=3D CHIP_ID_EM28174 ||
>>  	    dev->chip_id =3D=3D CHIP_ID_EM28178) {
>>  		/* The Transport Stream Enable Register moved in em2874 */
>> +		if (dev->dvb_xfer_bulk) {
>> +			/* Max Tx Size =3D 188 * 256 =3D 48128 - LCM(188,512) * 2 */
>> +			em28xx_write_reg(dev, (dev->ts =3D=3D PRIMARY_TS) ?
>> +					EM2874_R5D_TS1_PKT_SIZE :
>> +					EM2874_R5E_TS2_PKT_SIZE,
>> +					0xFF);
>> +		} else {
>> +			/* TS2 Maximum Transfer Size =3D 188 * 5 */
>> +			em28xx_write_reg(dev, (dev->ts =3D=3D PRIMARY_TS) ?
>> +					EM2874_R5D_TS1_PKT_SIZE :
>> +					EM2874_R5E_TS2_PKT_SIZE, 0x05);
>> +		}
> Hmm... for ISOC, the USB descriptors inform the max transfer size, with=

> are detected at probe time, on this part of em28xx_usb_probe:
>
> 	if (size > dev->dvb_max_pkt_size_isoc) {
> 		has_dvb =3D true; /* see NOTE (~) */
> 		dev->dvb_ep_isoc =3D e->bEndpointAddress;
> 		dev->dvb_max_pkt_size_isoc =3D size;
> 		dev->dvb_alt_isoc =3D i;
> 	}
>
> If we're touching TS PKT size register, it should somehow be
> aligned what's there. I mean, we should either do:
>
> 			em28xx_write_reg(dev, (dev->ts =3D=3D PRIMARY_TS) ?
> 					EM2874_R5D_TS1_PKT_SIZE :
> 					EM2874_R5E_TS2_PKT_SIZE, dev->dvb_max_pkt_size_isoc / 188);
>
> Or the other way around, setting dev->dvb_max_pkt_size_isoc after
> writing to EM2874_R5D_TS1_PKT_SIZE or EM2874_R5E_TS2_PKT_SIZE.
>
> Not sure what's more accurate here: the USB descriptors or the
> contents of the TS size register. I doubt, I would stick with
> the USB descriptor info.
>
> Btw, I wander what happens if we write a bigger value than 5 to those
> registers. Would it support a bigger transfer size than 940 for ISOCH?
>
>
>
> Cheers,
> Mauro

Hi Mauro,

On the one ISOC device I have here, the usb endpoint
dvb_max_pkt_size_isoc is 940 during usb_probe and
EM2874_R5D_TS1_PKT_SIZE returns 5 when queried in start_streaming. I
just did a little checking and EM2874_R5D_TS1_PKT_SIZE accepted, and
returned the value I wrote all the way up to 32. The device is DVB
however, so I cannot test actual operation to see if it increases ISOC
packet size at all. We're just going on what Empia said here for the
maximum of 5.

I agree that this is probably more correct to use (dvb_max_pkt_size_isoc
/ 188) instead of a hardcoded 5. This at least would keep devices with
other multipliers happy. Your second method of querying the multiplier
before setting up the endpoint would require a re-organization of
usb_probe to move em28xx_init_dev higher.

I'll submit a v2 of this briefly.

Cheers,

Brad
