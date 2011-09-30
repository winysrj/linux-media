Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab1I3L7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 07:59:19 -0400
Message-ID: <4E85AF12.1000700@infradead.org>
Date: Fri, 30 Sep 2011 08:59:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
CC: LMML <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	devin heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner)
 - workaround hack included
References: <201109281350.52099.simon.farnsworth@onelan.com> <4E859E74.7080900@infradead.org> <201109301203.36370.simon.farnsworth@onelan.co.uk>
In-Reply-To: <201109301203.36370.simon.farnsworth@onelan.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-09-2011 08:03, Simon Farnsworth escreveu:
> On Friday 30 September 2011, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>> Em 28-09-2011 09:50, Simon Farnsworth escreveu:
>>> (note - the CC list is everyone over 50% certainty from get_maintainer.pl)
>>>
>>> I'm having problems getting a Hauppauge HVR-1110 card to successfully
>>> tune PAL-D at 85.250 MHz vision frequency; by experimentation, I've
>>> determined that the tda18271 is tuning to a frequency 1.25 MHz lower
>>> than the vision frequency I've requested, so the following workaround
>>> "fixes" it for me.
>>>
>>> diff --git a/drivers/media/common/tuners/tda18271-fe.c 
>>> b/drivers/media/common/tuners/tda18271-fe.c
>>> index 63cc400..1a94e1a 100644
>>> --- a/drivers/media/common/tuners/tda18271-fe.c
>>> +++ b/drivers/media/common/tuners/tda18271-fe.c
>>> @@ -1031,6 +1031,7 @@ static int tda18271_set_analog_params(struct 
>>> dvb_frontend *fe,
>>>  		mode = "I";
>>>  	} else if (params->std & V4L2_STD_DK) {
>>>  		map = &std_map->atv_dk;
>>> +                freq += 1250000;
>>>  		mode = "DK";
>>>  	} else if (params->std & V4L2_STD_SECAM_L) {
>>>  		map = &std_map->atv_l;
>>
>> If I am to fix this bug, instead of a hack like that, it seems to be better
>> to split the .atv_dk line at the struct tda18271_std_map maps on
>> drivers/media/common/tuners/tda18271-maps.c.
>>
>> Looking at the datasheet, on page 43, available at:
>> 	http://www.nxp.com/documents/data_sheet/TDA18271HD.pdf
>>
>> The offset values for IF seem ok, but maybe your device is using some variant
>> of this chip that requires a different maps table.
>>
> How would I identify this? I definitely need the hack on multiple different
> HVR1110 cards, in different motherboards.

Michael/Devin may be able to double check what tda18271 variants are used at the
hvr1100 supported models.

It seems that there are 5 HVR-1100 model variants:

drivers/media/video/saa7134/saa7134-cards.c:      case 67019: /* WinTV-HVR1110 (Retail, IR Blaster, hybrid, FM, SVid/Comp, 3.5mm audio in) */
drivers/media/video/saa7134/saa7134-cards.c:      case 67209: /* WinTV-HVR1110 (Retail, IR Receive, hybrid, FM, SVid/Comp, 3.5mm audio in) */
drivers/media/video/saa7134/saa7134-cards.c:      case 67559: /* WinTV-HVR1110 (OEM, no IR, hybrid, FM, SVid/Comp, RCA aud) */
drivers/media/video/saa7134/saa7134-cards.c:      case 67569: /* WinTV-HVR1110 (OEM, no IR, hybrid, FM) */
drivers/media/video/saa7134/saa7134-cards.c:      case 67579: /* WinTV-HVR1110 (OEM, no IR, hybrid, no FM) */

> I get apparently perfect reception
> if I apply the hack, so clearly something is wrong.

Yes, but, on the other hand, if the device has the C2 or HD variant of tda18271,
the driver locks correct, acording with the datasheet.

Cheers,
Mauro
