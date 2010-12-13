Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:28507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641Ab0LMSjd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 13:39:33 -0500
Message-ID: <4D06697C.3020902@redhat.com>
Date: Mon, 13 Dec 2010 19:44:12 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 6/6] gspca - sonixj: Better handling of the bridge registers
 0x01 and 0x17
References: <20101213140430.576c0fc1@tele> <4D061F3C.8060101@redhat.com>
In-Reply-To: <4D061F3C.8060101@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 12/13/2010 02:27 PM, Mauro Carvalho Chehab wrote:
> Em 13-12-2010 11:04, Jean-Francois Moine escreveu:
>>
> I'm not sure about this... On my tests with the two devices I have with ov7660
> (sn9c105 and sn9c120), the original driver uses 48 MHz for all resolutions.
>

My 2 cents:

In my experience when (windows) drivers tend to play with the clockrate / clock
dividers on the basis of the mode / resolution this is because of bandwidth
constrains. So the question is what framerate does the 48 Mhz clock give us and
(assuming the highest alt setting, here we go again) what framerate can the
bridge / usb bus handle at the highest resolution (assuming worst case
compression).

Regards,

Hans




>>   		break;
>>   	case SENSOR_PO1030:
>>   		init = po1030_sensor_param1;
>> -		reg17 = 0xa2;
>> -		reg1 = 0x44;
>> +		reg01 |= SYS_SEL_48M;
>>   		break;
>>   	case SENSOR_PO2030N:
>>   		init = po2030n_sensor_param1;
>> -		reg1 = 0x46;
>> -		reg17 = 0xa2;
>> +		reg01 |= SYS_SEL_48M;
>>   		break;
>>   	case SENSOR_SOI768:
>>   		init = soi768_sensor_param1;
>> -		reg1 = 0x44;
>> -		reg17 = 0xa2;
>> +		reg01 |= SYS_SEL_48M;
>>   		break;
>>   	case SENSOR_SP80708:
>>   		init = sp80708_sensor_param1;
>> -		if (mode) {
>> -/*??			reg1 = 0x04;	 * 320 clk 48Mhz */
>> -		} else {
>> -			reg1 = 0x46;	 /* 640 clk 48Mz */
>> -			reg17 = 0xa2;
>> -		}
>>   		break;
>>   	}
>>
>> @@ -2695,7 +2604,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
>>   	setjpegqual(gspca_dev);
>>
>>   	reg_w1(gspca_dev, 0x17, reg17);
>> -	reg_w1(gspca_dev, 0x01, reg1);
>> +	reg_w1(gspca_dev, 0x01, reg01);
>> +	sd->reg01 = reg01;
>> +	sd->reg17 = reg17;
>>
>>   	sethvflip(gspca_dev);
>>   	setbrightness(gspca_dev);
>> @@ -2717,41 +2628,69 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
>>   		{ 0xa1, 0x21, 0x76, 0x20, 0x00, 0x00, 0x00, 0x10 };
>>   	static const u8 stopsoi768[] =
>>   		{ 0xa1, 0x21, 0x12, 0x80, 0x00, 0x00, 0x00, 0x10 };
>> -	u8 data;
>> -	const u8 *sn9c1xx;
>> +	u8 reg01;
>> +	u8 reg17;
>>
>> -	data = 0x0b;
>> +	reg01 = sd->reg01;
>> +	reg17 = sd->reg17&  ~SEN_CLK_EN;
>>   	switch (sd->sensor) {
>> +	case SENSOR_ADCM1700:
>> +	case SENSOR_PO2030N:
>> +	case SENSOR_SP80708:
>> +		reg01 |= LED;
>> +		reg_w1(gspca_dev, 0x01, reg01);
>> +		reg01&= ~(LED | V_TX_EN);
>> +		reg_w1(gspca_dev, 0x01, reg01);
>> +/*		reg_w1(gspca_dev, 0x02, 0x??);	 * LED off ? */
>> +		break;
>>   	case SENSOR_GC0307:
>> -		data = 0x29;
>> +		reg01 |= LED | S_PDN_INV;
>> +		reg_w1(gspca_dev, 0x01, reg01);
>> +		reg01&= ~(LED | V_TX_EN | S_PDN_INV);
>
> Touching at S_PDN_INV here seems wrong. sd->reg01 has already the S_PDN_INV
> value stored there, for devices that require it.
>
> The right thing would be to use S_PWR_DN. If you got this from the original
> driver USB dump, my guess is that the developer of the original driver got
> the wrong bit by mistake. Of course, I may be wrong here.
>
>
>> +		reg_w1(gspca_dev, 0x01, reg01);
>>   		break;
>>   	case SENSOR_HV7131R:
>> +		reg01&= ~V_TX_EN;
>> +		reg_w1(gspca_dev, 0x01, reg01);
>>   		i2c_w8(gspca_dev, stophv7131);
>> -		data = 0x2b;
>>   		break;
>>   	case SENSOR_MI0360:
>>   	case SENSOR_MI0360B:
>> +		reg01&= ~V_TX_EN;
>> +		reg_w1(gspca_dev, 0x01, reg01);
>> +/*		reg_w1(gspca_dev, 0x02, 0x40);	  * LED off ? */
>>   		i2c_w8(gspca_dev, stopmi0360);
>> -		data = 0x29;
>>   		break;
>> -	case SENSOR_OV7648:
>> -		i2c_w8(gspca_dev, stopov7648);
>> -		/* fall thru */
>>   	case SENSOR_MT9V111:
>> -	case SENSOR_OV7630:
>> +	case SENSOR_OM6802:
>>   	case SENSOR_PO1030:
>> -		data = 0x29;
>> +		reg01&= ~V_TX_EN;
>> +		reg_w1(gspca_dev, 0x01, reg01);
>> +		break;
>> +	case SENSOR_OV7630:
>> +	case SENSOR_OV7648:
>> +		reg01&= ~V_TX_EN;
>> +		reg_w1(gspca_dev, 0x01, reg01);
>> +		i2c_w8(gspca_dev, stopov7648);
>> +		break;
>> +	case SENSOR_OV7660:
>> +		reg01&= ~V_TX_EN;
>> +		reg_w1(gspca_dev, 0x01, reg01);
>>   		break;
>>   	case SENSOR_SOI768:
>>   		i2c_w8(gspca_dev, stopsoi768);
>> -		data = 0x29;
>>   		break;
>>   	}
>> -	sn9c1xx = sn_tb[sd->sensor];
>> -	reg_w1(gspca_dev, 0x01, sn9c1xx[1]);
>> -	reg_w1(gspca_dev, 0x17, sn9c1xx[0x17]);
>> -	reg_w1(gspca_dev, 0x01, sn9c1xx[1]);
>> -	reg_w1(gspca_dev, 0x01, data);
>> +
>> +	reg01 |= SCL_SEL_OD;
>> +	reg_w1(gspca_dev, 0x01, reg01);
>> +	reg01 |= S_PWR_DN;		/* sensor power down */
>> +	reg_w1(gspca_dev, 0x01, reg01);
>> +	reg_w1(gspca_dev, 0x17, reg17);
>> +	reg01&= ~SYS_SEL_48M;		/* clock 24MHz */
>> +	reg_w1(gspca_dev, 0x01, reg01);
>> +	reg01 |= LED;
>> +	reg_w1(gspca_dev, 0x01, reg01);
>>   	/* Don't disable sensor clock as that disables the button on the cam */
>>   	/* reg_w1(gspca_dev, 0xf1, 0x01); */
>>   }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
