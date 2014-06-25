Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58215 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbaFYKci (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 06:32:38 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so2216543wib.15
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 03:32:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403615732-9193-1-git-send-email-crope@iki.fi>
References: <1403615732-9193-1-git-send-email-crope@iki.fi>
Date: Wed, 25 Jun 2014 20:32:34 +1000
Message-ID: <CAM187nByJMOmOrYJPKfZ0WyrARSD1+eAyoEOKahDiGyk9no5qw@mail.gmail.com>
Subject: Re: [PATCH] af9035: override tuner id when bad value set into eeprom
From: David Shirley <tephra@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Unname <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patched vanilla 3.15.1, this is the dmesg:

Jun 25 20:16:16 crystal kernel: [  136.546403] usb 3-4.1.2: new
high-speed USB device number 9 using xhci_hcd
Jun 25 20:16:16 crystal kernel: [  136.634428] usb 3-4.1.2: New USB
device found, idVendor=0413, idProduct=6a05
Jun 25 20:16:16 crystal kernel: [  136.634435] usb 3-4.1.2: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Jun 25 20:16:16 crystal kernel: [  136.634438] usb 3-4.1.2: Product:
WinFast DTV Dongle Dual
Jun 25 20:16:16 crystal kernel: [  136.634441] usb 3-4.1.2:
Manufacturer: Leadtek
Jun 25 20:16:16 crystal kernel: [  136.643754] usb 3-4.1.2:
dvb_usb_af9035: prechip_version=83 chip_version=02 chip_type=9135
Jun 25 20:16:16 crystal kernel: [  136.644100] usb 3-4.1.2:
dvb_usb_v2: found a 'Leadtek WinFast DTV Dongle Dual' in cold state
Jun 25 20:16:16 crystal kernel: [  136.644429] usb 3-4.1.2:
dvb_usb_v2: downloading firmware from file 'dvb-usb-it9135-02.fw'
Jun 25 20:16:18 crystal kernel: [  138.553335] usb 3-4.1.2:
dvb_usb_af9035: firmware version=3.39.1.0
Jun 25 20:16:18 crystal kernel: [  138.553350] usb 3-4.1.2:
dvb_usb_v2: found a 'Leadtek WinFast DTV Dongle Dual' in warm state
Jun 25 20:16:18 crystal kernel: [  138.555176] usb 3-4.1.2:
dvb_usb_af9035: [0] overriding tuner from 38 to 60
Jun 25 20:16:18 crystal kernel: [  138.556515] usb 3-4.1.2:
dvb_usb_af9035: [1] overriding tuner from 38 to 60
Jun 25 20:16:18 crystal kernel: [  138.557900] usb 3-4.1.2:
dvb_usb_v2: will pass the complete MPEG2 transport stream to the
software demuxer
Jun 25 20:16:18 crystal kernel: [  138.557957] DVB: registering new
adapter (Leadtek WinFast DTV Dongle Dual)
Jun 25 20:16:18 crystal kernel: [  138.564417] i2c i2c-11: af9033:
firmware version: LINK=0.0.0.0 OFDM=3.9.1.0
Jun 25 20:16:18 crystal kernel: [  138.564446] usb 3-4.1.2: DVB:
registering adapter 2 frontend 0 (Afatech AF9033 (DVB-T))...
Jun 25 20:16:18 crystal kernel: [  138.568091] i2c i2c-11:
tuner_it913x: ITE Tech IT913X successfully attached
Jun 25 20:16:18 crystal kernel: [  138.568110] usb 3-4.1.2:
dvb_usb_v2: will pass the complete MPEG2 transport stream to the
software demuxer
Jun 25 20:16:18 crystal kernel: [  138.568139] DVB: registering new
adapter (Leadtek WinFast DTV Dongle Dual)
Jun 25 20:16:18 crystal kernel: [  138.580208] i2c i2c-11: af9033:
firmware version: LINK=0.0.0.0 OFDM=3.9.1.0
Jun 25 20:16:18 crystal kernel: [  138.580219] usb 3-4.1.2: DVB:
registering adapter 3 frontend 0 (Afatech AF9033 (DVB-T))...
Jun 25 20:16:18 crystal kernel: [  138.580364] i2c i2c-11:
tuner_it913x: ITE Tech IT913X successfully attached
Jun 25 20:16:18 crystal kernel: [  138.591871] Registered IR keymap rc-empty
Jun 25 20:16:18 crystal kernel: [  138.591995] input: Leadtek WinFast
DTV Dongle Dual as
/devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1.2/rc/rc2/input11
Jun 25 20:16:18 crystal kernel: [  138.592069] rc2: Leadtek WinFast
DTV Dongle Dual as
/devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1.2/rc/rc2
Jun 25 20:16:18 crystal kernel: [  138.592075] usb 3-4.1.2:
dvb_usb_v2: schedule remote query interval to 500 msecs
Jun 25 20:16:18 crystal kernel: [  138.592078] usb 3-4.1.2:
dvb_usb_v2: 'Leadtek WinFast DTV Dongle Dual' successfully initialized
and connected
Jun 25 20:16:18 crystal kernel: [  138.592113] usbcore: registered new
interface driver dvb_usb_af9035

I can confirm that this tuner now works on the 9035 driver.

However, im not sure if its the tuner thats just crap or my signal
strength, as an AF9013 can tune and get ok reception, but this IT913X
can tune but barely maintain a good picture. ITE say this particular
tuner requires 2db more so I guess its feasible my 9013's are right on
the border and the 9137 just cant "do it" :)

I have a new antenna going in on the weekend so I will report back then!

Merci!
D.

On 24 June 2014 23:15, Antti Palosaari <crope@iki.fi> wrote:
> Tuner ID set into EEPROM is wrong in some cases, which causes driver
> to select wrong tuner profile. That leads device non-working. Fix
> issue by overriding known bad tuner IDs with suitable default value.
>
> Cc: stable@vger.kernel.org # v3.15+
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/af9035.c | 40 +++++++++++++++++++++++++++++------
>  1 file changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 021e4d3..7b9b75f 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -704,15 +704,41 @@ static int af9035_read_config(struct dvb_usb_device *d)
>                 if (ret < 0)
>                         goto err;
>
> -               if (tmp == 0x00)
> -                       dev_dbg(&d->udev->dev,
> -                                       "%s: [%d]tuner not set, using default\n",
> -                                       __func__, i);
> -               else
> +               dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
> +                               __func__, i, tmp);
> +
> +               /* tuner sanity check */
> +               if (state->chip_type == 0x9135) {
> +                       if (state->chip_version == 0x02) {
> +                               /* IT9135 BX (v2) */
> +                               switch (tmp) {
> +                               case AF9033_TUNER_IT9135_60:
> +                               case AF9033_TUNER_IT9135_61:
> +                               case AF9033_TUNER_IT9135_62:
> +                                       state->af9033_config[i].tuner = tmp;
> +                                       break;
> +                               }
> +                       } else {
> +                               /* IT9135 AX (v1) */
> +                               switch (tmp) {
> +                               case AF9033_TUNER_IT9135_38:
> +                               case AF9033_TUNER_IT9135_51:
> +                               case AF9033_TUNER_IT9135_52:
> +                                       state->af9033_config[i].tuner = tmp;
> +                                       break;
> +                               }
> +                       }
> +               } else {
> +                       /* AF9035 */
>                         state->af9033_config[i].tuner = tmp;
> +               }
>
> -               dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
> -                               __func__, i, state->af9033_config[i].tuner);
> +               if (state->af9033_config[i].tuner != tmp) {
> +                       dev_info(&d->udev->dev,
> +                                       "%s: [%d] overriding tuner from %02x to %02x\n",
> +                                       KBUILD_MODNAME, i, tmp,
> +                                       state->af9033_config[i].tuner);
> +               }
>
>                 switch (state->af9033_config[i].tuner) {
>                 case AF9033_TUNER_TUA9001:
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
