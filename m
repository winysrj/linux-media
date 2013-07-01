Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55552 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab3GANhG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 09:37:06 -0400
Message-ID: <51D185D7.2080107@iki.fi>
Date: Mon, 01 Jul 2013 16:36:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: Bogdan Oprea <bogdaninedit@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: drivers:media:tuners:fc2580c fix for Asus U3100Mini Plus error
 while loading driver (-19)
References: <1372660460.41879.YahooMailNeo@web162304.mail.bf1.yahoo.com> <1372661590.52145.YahooMailNeo@web162304.mail.bf1.yahoo.com> <51D1352A.2080107@schinagl.nl> <51D182CD.2040502@iki.fi> <51D1839B.1010007@schinagl.nl>
In-Reply-To: <51D1839B.1010007@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2013 04:26 PM, Oliver Schinagl wrote:
> On 01-07-13 15:23, Antti Palosaari wrote:
>> On 07/01/2013 10:52 AM, Oliver Schinagl wrote:
>>> On 01-07-13 08:53, Bogdan Oprea wrote:
>>>> this is a fix for this type of error
>>>>
>>>> [18384.579235] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' error while
>>>> loading driver (-19)
>>>> [18384.580621] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' successfully
>>>> deinitialized and disconnected
>>>>
>>> This isn't really a fix, I think i mentioned this on the ML ages ago,
>>
>> Argh, I just replied that same. Oliver, do you has that same device? Is
>> it working? Could you tweak to see if I2C readings are working at all?
> I have the same device, but mine works normally (though I haven't
> checked for ages), I will try it tonight when I'm at home and don't
> forget what happens with my current kernel.

Actually, I has RTL2832U + FC2580, and it works. It is not Asus 
U3100Mini Plus.

Reading of that chip id must be working on the very first, is RTL2832U 
driver detects whole tuner by probing it.

	/* check FC2580 ID register; reg=01 val=56 */
	ret = rtl28xxu_ctrl_msg(d, &req_fc2580);
	if (ret == 0 && buf[0] == 0x56) {
		priv->tuner = TUNER_RTL2832_FC2580;
		priv->tuner_name = "FC2580";
		goto found;
	}

So I wonder if tuner I2C readings starts failing after that.

regards
Antti

-- 
http://palosaari.fi/
