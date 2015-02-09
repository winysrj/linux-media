Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46920 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbbBIHtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 02:49:23 -0500
Received: by iecar1 with SMTP id ar1so14561772iec.13
        for <linux-media@vger.kernel.org>; Sun, 08 Feb 2015 23:49:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <trinity-50c1b2fb-3f4b-43e8-9eae-85e905ff7834-1423426659156@3capp-gmx-bs34>
References: <trinity-50c1b2fb-3f4b-43e8-9eae-85e905ff7834-1423426659156@3capp-gmx-bs34>
Date: Mon, 9 Feb 2015 09:49:21 +0200
Message-ID: <CAAZRmGxWq21ygcUQu6WSMNnNHD_3vjS-=U687y_VbUOxfaysuA@mail.gmail.com>
Subject: Re: TechnoTrend TT-TVStick CT2-4400v2 no firmware load
From: Olli Salonen <olli.salonen@iki.fi>
To: =?UTF-8?Q?Sebastian_S=C3=BCsens?= <S.Suesens@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The si2168 and si2157 firmware is loaded when you try to use the tuner
for the first time, not at the time of module load or device plugin.

Cheers,
-olli

On 8 February 2015 at 22:17, "Sebastian Süsens" <S.Suesens@gmx.de> wrote:
> Hello,
> I use kernel 3.13.0 and the media_build "4e1a67e4a6c8ab71f416ea32059c92171407ba5d".
>
> I get following messages by dmesg:
>
> [ 1543.444128] usb 2-4: new high-speed USB device number 4 using ehci-pci
> [ 1543.577069] usb 2-4: New USB device found, idVendor=0b48, idProduct=3014
> [ 1543.577088] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [ 1543.577098] usb 2-4: Product: TechnoTrend USB-Stick
> [ 1543.577106] usb 2-4: Manufacturer: CityCom GmbH
> [ 1543.577114] usb 2-4: SerialNumber: 20131128
> [ 1543.764126] usb 2-4: dvb_usb_v2: found a 'TechnoTrend TVStick CT2-4400' in warm state
> [ 1543.764317] usb 2-4: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
> [ 1543.764387] DVB: registering new adapter (TechnoTrend TVStick CT2-4400)
> [ 1543.765811] usb 2-4: dvb_usb_v2: MAC address: bc:ea:2b:44:02:7c
> [ 1543.772724] i2c i2c-2: Added multiplexed i2c bus 3
> [ 1543.772734] si2168 2-0064: Silicon Labs Si2168 successfully attached
> [ 1543.777532] si2157 3-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
> [ 1543.777579] usb 2-4: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
> [ 1543.777824] Registered IR keymap rc-tt-1500
> [ 1543.778051] input: TechnoTrend TVStick CT2-4400 as /devices/pci0000:00/0000:00:13.2/usb2/2-4/rc/rc0/input18
> [ 1543.778368] rc0: TechnoTrend TVStick CT2-4400 as /devices/pci0000:00/0000:00:13.2/usb2/2-4/rc/rc0
> [ 1543.778382] usb 2-4: dvb_usb_v2: schedule remote query interval to 300 msecs
> [ 1543.778396] usb 2-4: dvb_usb_v2: 'TechnoTrend TVStick CT2-4400' successfully initialized and connected
>
> I see no message about the firmware loading is this correct?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
