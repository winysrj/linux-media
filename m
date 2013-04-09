Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33706 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765118Ab3DITp3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 15:45:29 -0400
Message-ID: <51646FAF.3000400@iki.fi>
Date: Tue, 09 Apr 2013 22:44:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] block i2c tuner reads for Avermedia Twinstar in the af9035
 driver
References: <4261811.IXtDYhFBCx@jar7.dominio> <5146399E.8070404@iki.fi> <1602162.t6BDYGs1VX@jar7.dominio> <2287805.aTCpuP2IDP@jar7.dominio>
In-Reply-To: <2287805.aTCpuP2IDP@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2013 02:53 PM, Jose Alberto Reguero wrote:
> On Domingo, 24 de marzo de 2013 20:39:15 Jose Alberto Reguero escribió:
>> On Domingo, 17 de marzo de 2013 23:46:06 Antti Palosaari escribió:
>>> On 03/17/2013 08:49 PM, Jose Alberto Reguero wrote:
>>>> On Martes, 12 de marzo de 2013 00:11:38 Antti Palosaari escribió:
>>>>> On 03/11/2013 10:02 PM, Jose Alberto Reguero wrote:
>>>>>> On Lunes, 11 de marzo de 2013 14:57:37 Antti Palosaari escribió:
>>>>>>> On 03/11/2013 01:51 PM, Jose Alberto Reguero wrote:
>>>>>>>> On Lunes, 11 de febrero de 2013 14:48:18 Jose Alberto Reguero
>>
>> escribió:
>>>>>>>>> On Domingo, 10 de febrero de 2013 22:11:53 Antti Palosaari
> escribió:
>>>>>>>>>> On 02/10/2013 09:43 PM, Jose Alberto Reguero wrote:
>>>>>>>>>>> This patch block the i2c tuner reads for Avermedia Twinstar. If
>>>>>>>>>>> it's
>>>>>>>>>>> needed other pids can be added.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
>>>>>>>>>>>
>>>>>>>>>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>>>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c ---
>>>>>>>>>>> linux/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-07
>>>>>>>>>>> 05:45:57.000000000 +0100 +++
>>>>>>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2013-02-08
>>>>>>>>>>> 22:55:08.304089054 +0100 @@ -232,7 +232,11 @@ static int
>>>>>>>>>>> af9035_i2c_master_xfer(struct
>>>>>>>>>>>
>>>>>>>>>>>       			buf[3] = 0x00; /* reg addr MSB */
>>>>>>>>>>>       			buf[4] = 0x00; /* reg addr LSB */
>>>>>>>>>>>       			memcpy(&buf[5], msg[0].buf, msg[0].len);
>>>>>>>>>>>
>>>>>>>>>>> -			ret = af9035_ctrl_msg(d, &req);
>>>>>>>>>>> +			if (state->block_read) {
>>>>>>>>>>> +				msg[1].buf[0] = 0x3f;
>>>>>>>>>>> +				ret = 0;
>>>>>>>>>>> +			} else
>>>>>>>>>>> +				ret = af9035_ctrl_msg(d, &req);
>>>>>>>>>>>
>>>>>>>>>>>       		}
>>>>>>>>>>>       	
>>>>>>>>>>>       	} else if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
>>>>>>>>>>>       	
>>>>>>>>>>>       		if (msg[0].len > 40) {
>>>>>>>>>>>
>>>>>>>>>>> @@ -638,6 +642,17 @@ static int af9035_read_config(struct dvb
>>>>>>>>>>>
>>>>>>>>>>>       	for (i = 0; i < ARRAY_SIZE(state->af9033_config); i++)
>>>>>>>>>>>       	
>>>>>>>>>>>       		state->af9033_config[i].clock = clock_lut[tmp];
>>>>>>>>>>>
>>>>>>>>>>> +	state->block_read = false;
>>>>>>>>>>> +
>>>>>>>>>>> +	if (le16_to_cpu(d->udev->descriptor.idVendor) ==
>>>>>>>>>>> USB_VID_AVERMEDIA
>>>>>>>>>>> &&
>>>>>>>>>>> +		le16_to_cpu(d->udev->descriptor.idProduct) ==
>>>>>>>>>>> +			USB_PID_AVERMEDIA_TWINSTAR) {
>>>>>>>>>>> +		dev_dbg(&d->udev->dev,
>>>>>>>>>>> +				"%s: AverMedia Twinstar: block i2c read from tuner\n",
>>>>>>>>>>> +				__func__);
>>>>>>>>>>> +		state->block_read = true;
>>>>>>>>>>> +	}
>>>>>>>>>>> +
>>>>>>>>>>>
>>>>>>>>>>>       	return 0;
>>>>>>>>>>>
>>>>>>>>>>>       err:
>>>>>>>>>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h
>>>>>>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.h ---
>>>>>>>>>>> linux/drivers/media/usb/dvb-usb-v2/af9035.h	2013-01-07
>>>>>>>>>>> 05:45:57.000000000 +0100 +++
>>>>>>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2013-02-08
>>>>>>>>>>> 22:52:42.293842710 +0100 @@ -54,6 +54,7 @@ struct usb_req {
>>>>>>>>>>>
>>>>>>>>>>>       struct state {
>>>>>>>>>>>
>>>>>>>>>>>       	u8 seq; /* packet sequence number */
>>>>>>>>>>>       	bool dual_mode;
>>>>>>>>>>>
>>>>>>>>>>> +	bool block_read;
>>>>>>>>>>>
>>>>>>>>>>>       	struct af9033_config af9033_config[2];
>>>>>>>>>>>
>>>>>>>>>>>       };
>>>>>>>>>>
>>>>>>>>>> Could you test if faking tuner ID during attach() is enough?
>>>>>>>>>>
>>>>>>>>>> Also, I would like to know what is returned error code from
>>>>>>>>>> firmware
>>>>>>>>>> when it fails. Enable debugs to see it. It should print something
>>>>>>>>>> like
>>>>>>>>>> that: af9035_ctrl_msg: command=03 failed fw error=2
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>>>>>>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>>>>>>> index a1e953a..5a4f28d 100644
>>>>>>>>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>>>>>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>>>>>>> @@ -1082,9 +1082,22 @@ static int af9035_tuner_attach(struct
>>>>>>>>>> dvb_usb_adapter *adap)
>>>>>>>>>>
>>>>>>>>>>                              tuner_addr = 0x60 | 0x80; /* I2C bus
>>>>>>>>>>                              hack
>>>>>>>>>>                              */
>>>>>>>>>>
>>>>>>>>>>                      }
>>>>>>>>>>
>>>>>>>>>> +               // fake used tuner for demod firmware / i2c
>>>>>>>>>> adapter
>>>>>>>>>> +               if (adap->id == 0)
>>>>>>>>>> +                       ret = af9035_wr_reg(d, 0x00f641,
>>>>>>>>>> AF9033_TUNER_FC0011);
>>>>>>>>>> +               else
>>>>>>>>>> +                       ret = af9035_wr_reg(d, 0x10f641,
>>>>>>>>>> AF9033_TUNER_FC0011);
>>>>>>>>>> +
>>>>>>>>>>
>>>>>>>>>>                      /* attach tuner */
>>>>>>>>>>                      fe = dvb_attach(mxl5007t_attach, adap->fe[0],
>>>>>>>>>>                      &d->i2c_adap,
>>>>>>>>>>
>>>>>>>>>>                                      tuner_addr,
>>>>>>>>>>
>>>>>>>>>> &af9035_mxl5007t_config[adap->id]);
>>>>>>>>>> +
>>>>>>>>>> +               // return correct tuner
>>>>>>>>>> +               if (adap->id == 0)
>>>>>>>>>> +                       ret = af9035_wr_reg(d, 0x00f641,
>>>>>>>>>> AF9033_TUNER_MXL5007T);
>>>>>>>>>> +               else
>>>>>>>>>> +                       ret = af9035_wr_reg(d, 0x10f641,
>>>>>>>>>> AF9033_TUNER_MXL5007T);
>>>>>>>>>> +
>>>>>>>>>>
>>>>>>>>>>                      break;
>>>>>>>>>>
>>>>>>>>>>              case AF9033_TUNER_TDA18218:
>>>>>>>>>>                      /* attach tuner */
>>>>>>>>>>
>>>>>>>>>> regards
>>>>>>>>>> Antti
>>>>>>>>>
>>>>>>>>> I will try with fake tuner, but I can't test unil next weekend.
>>>>>>>>> If I remember, the read operation is performed, and return good
>>>>>>>>> value,
>>>>>>>>> but after that, all the i2c transfers fail. Seee:
>>>>>>>>>
>>>>>>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg56346.ht
>>>>>>>>> ml
>>>>>>>>>
>>>>>>>>> Jose Alberto
>>>>>>>>
>>>>>>>> I tried with fake tuner without success:
>>>>>>>>
>>>>>>>> [ 1346.707405] DVB: registering new adapter (AVerMedia Twinstar
>>>>>>>> (A825))
>>>>>>>> [ 1346.959043] i2c i2c-1: af9033: firmware version: LINK=11.5.9.0
>>>>>>>> OFDM=5.17.9.1
>>>>>>>> [ 1346.962920] usb 1-2: DVB: registering adapter 0 frontend 0
>>>>>>>> (Afatech
>>>>>>>> AF9033 (DVB-T))...
>>>>>>>> [ 1347.439354] mxl5007t 1-0060: creating new instance
>>>>>>>> [ 1347.440644] mxl5007t_get_chip_id: unknown rev (3f)
>>>>>>>> [ 1347.440652] mxl5007t_get_chip_id: MxL5007T detected @ 1-0060
>>>>>>>> [ 1347.443023] mxl5007t_write_reg: 472: failed!
>>>>>>>> [ 1347.443031] mxl5007t_attach: error -121 on line 903
>>>>>>>> [ 1347.443790] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)'
>>>>>>>> error
>>>>>>>> while
>>>>>>>> loading driver (-19)
>>>>>>>> [ 1347.446624] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)'
>>>>>>>> successfully deinitialized and disconnected
>>>>>>>
>>>>>>> I don't see how the hell it could even go to the mxl5007t_write_reg()
>>>>>>> during attach. Any idea?
>>>>>>
>>>>>> Now with the patches I sent for mxl5007 in the attach function
>>>>>> mxl5007t_soft_reset is called, and also  loop_thru_enable is writed.
>>>>>> The
>>>>>> problem is that the read is performed and it return a good value, but
>>>>>> the
>>>>>> next writes fail.
>>>>>>
>>>>>>> I have some thoughts that mxl5007t do not use repeated condition.
>>>>>>> Driver
>>>>>>> still does that. Could you test to perform register read without a
>>>>>>> repeated I2C condition?
>>>>>>
>>>>>> How I can do that? what it is a repeated i2c condition?
>>>>>
>>>>> You should take a look for I2C specification.
>>>>>
>>>>> Please test that:
>>>>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035
>>>>> _i
>>>>> 2c_ mxl5007t_test
>>>>>
>>>>> It fixes similar issue of AF9015 driver :)
>>>>>
>>>>> I am not able to test AF9035 as I have no hw. It is compile tested
>>>>> only.
>>>>> Try to do some tweaking for AF9035 implementation if it does not work!
>>>>>
>>>>> regards
>>>>> Antti
>>>>
>>>> I try with the i2c changes of your tree, and don't work, but there are
>>>> some
>>>> differences. With the i2c changes now the chip is recognized as
>>>> MxL5007T.v4
>>>> and without the changes the chip is recognized as unknown rev (3f). But
>>>> the
>>>> problem after the i2c read persit.
>>>>
>>>> [ 1784.774117] DVB: registering new adapter (AVerMedia Twinstar (A825))
>>>> [ 1784.877636] i2c i2c-4: af9033: firmware version: LINK=11.5.9.0
>>>> OFDM=5.17.9.1
>>>> [ 1784.884771] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech
>>>> AF9033 (DVB-T))...
>>>> [ 1785.274753] mxl5007t 4-0060: creating new instance
>>>> [ 1785.276886] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 4-0060
>>>> [ 1785.279252] mxl5007t_write_reg: 472: failed!
>>>> [ 1785.279260] mxl5007t_attach: error -121 on line 940
>>>> [ 1785.279703] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error
>>>> while
>>>> loading driver (-19)
>>>> [ 1785.282377] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)'
>>>> successfully deinitialized and disconnected
>>>
>>> I have asked that earlier, but Haven't got answer. Could you say how it
>>> fails? mxl5007t is a little bit dummy and didn't print any hint why it
>>> fails - just set error -EREMOTEIO in any case.
>>>
>>> Enable dvb_usb_v2 and dvb_usb_af9035 debugs to see what it returns. I
>>> want to see those raw debug lines from dvb_usb_v2 + af9035 debugs.
>>>
>>> Also, could you add hw sniffer to I2C bus and look what goes there?
>>>
>>> regards
>>> Antti
>>
>> I can't make dynamic debug work, but I put some printks in af9035. The
>> result is:
>>
>> Witout i2c changes:
>>
>> [ 8433.114216] i2c i2c-1: af9033: firmware version: LINK=11.5.9.0
>> OFDM=5.17.9.1
>> [ 8433.119700] af9035_ctrl_msg: failed1=0
>> [ 8433.128423] af9035_ctrl_msg: failed1=0
>> [ 8433.128450] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech
>> AF9033 (DVB-T))...
>> [ 8433.128770] mxl5007t 1-00e0: creating new instance
>> [ 8433.134945] af9035_ctrl_msg: failed1=0
>> [ 8433.134962] mxl5007t_get_chip_id: unknown rev (3f)
>> [ 8433.134970] mxl5007t_get_chip_id: MxL5007T detected @ 1-00e0
>> [ 8433.141312] af9035_ctrl_msg: command=03 failed fw error=4
>> [ 8433.141324] af9035_ctrl_msg: failed2=-5
>> [ 8433.141332] mxl5007t_write_reg: 472: failed!
>> [ 8433.141340] mxl5007t_attach: error -121 on line 903
>> [ 8433.141737] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error while
>> loading driver (-19)
>> [ 8433.144481] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' successfully
>> deinitialized and disconnected
>>
>> With i2c changes:
>> [ 9300.143397] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech
>> AF9033 (DVB-T))...
>> [ 9300.144204] af9035_ctrl_msg: failed1=0
>> [ 9300.144620] af9035_ctrl_msg: failed1=0
>> [ 9300.144992] af9035_ctrl_msg: failed1=0
>> [ 9300.176123] af9035_ctrl_msg: failed1=0
>> [ 9300.478122] af9035_ctrl_msg: failed1=0
>> [ 9300.478484] af9035_ctrl_msg: failed1=0
>> [ 9300.478858] af9035_ctrl_msg: failed1=0
>> [ 9300.479245] af9035_ctrl_msg: failed1=0
>> [ 9300.479609] af9035_ctrl_msg: failed1=0
>> [ 9300.479984] af9035_ctrl_msg: failed1=0
>> [ 9300.518083] mxl5007t 1-0060: creating new instance
>> [ 9300.519179] af9035_ctrl_msg: failed1=0
>> [ 9300.520063] af9035_ctrl_msg: failed1=0
>> [ 9300.520083] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 1-0060
>> [ 9300.522498] af9035_ctrl_msg: command=03 failed fw error=4
>> [ 9300.522505] af9035_ctrl_msg: failed2=-5
>> [ 9300.522513] mxl5007t_write_reg: 472: failed!
>> [ 9300.522522] mxl5007t_attach: error -121 on line 940
>> [ 9300.522907] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error while
>> loading driver (-19)
>> [ 9300.525680] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' successfully
>> deinitialized and disconnected
>>
>>
>> Note that the read operation is performed without error, the error is in the
>> next write operation. ¿Do you need more detailed logs?
>>
>> Jose Alberto
>>
>
> More logs with dyndbg and without i2c changes:
>
> [ 6335.921238] i2c i2c-1: af9033: firmware version: LINK=11.5.9.0
> OFDM=5.17.9.1
> [ 6335.921256] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 80 01 0e 01 02 00 00 00
> 4c 01 23 fc
> [ 6335.921612] usb 1-2: dvb_usbv2_generic_rw: <<< 04 0e 00 f1 ff
> [ 6335.921630] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 80 01 0f 01 02 00 00 00
> 00 00 6e fd
> [ 6335.925240] usb 1-2: dvb_usbv2_generic_rw: <<< 04 0f 00 f0 ff
> [ 6335.925263] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9033
> (DVB-T))...
> [ 6335.927437] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 10 01 02 00 00 d8
> e0 01 0d 24
> [ 6335.927864] usb 1-2: dvb_usbv2_generic_rw: <<< 04 10 00 ef ff
> [ 6335.927881] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 11 01 02 00 00 d8
> e1 01 0b 24
> [ 6335.928363] usb 1-2: dvb_usbv2_generic_rw: <<< 04 11 00 ee ff
> [ 6335.928379] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 12 01 02 00 00 d8
> df 00 0c 25
> [ 6335.928851] usb 1-2: dvb_usbv2_generic_rw: <<< 04 12 00 ed ff
> [ 6335.959063] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 13 01 02 00 00 d8
> df 01 0b 24
> [ 6335.959460] usb 1-2: dvb_usbv2_generic_rw: <<< 04 13 00 ec ff
> [ 6336.260054] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 14 01 02 00 00 d8
> c0 01 29 24
> [ 6336.260460] usb 1-2: dvb_usbv2_generic_rw: <<< 04 14 00 eb ff
> [ 6336.260469] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 15 01 02 00 00 d8
> c1 01 27 24
> [ 6336.260833] usb 1-2: dvb_usbv2_generic_rw: <<< 04 15 00 ea ff
> [ 6336.260842] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 16 01 02 00 00 d8
> bf 00 28 25
> [ 6336.261220] usb 1-2: dvb_usbv2_generic_rw: <<< 04 16 00 e9 ff
> [ 6336.261233] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 17 01 02 00 00 d8
> b4 01 32 24
> [ 6336.261585] usb 1-2: dvb_usbv2_generic_rw: <<< 04 17 00 e8 ff
> [ 6336.261595] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 18 01 02 00 00 d8
> b5 01 30 24
> [ 6336.261959] usb 1-2: dvb_usbv2_generic_rw: <<< 04 18 00 e7 ff
> [ 6336.261968] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 19 01 02 00 00 d8
> b3 01 31 24
> [ 6336.262342] usb 1-2: dvb_usbv2_generic_rw: <<< 04 19 00 e6 ff
> [ 6336.269889] mxl5007t 1-0060: creating new instance
> [ 6336.269918] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 02 1a 01 c0 00 00 00
> fb d9 2a 23
> [ 6336.270739] usb 1-2: dvb_usbv2_generic_rw: <<< 05 1a 00 3f a6 ff
> [ 6336.270752] mxl5007t_get_chip_id: unknown rev (3f)
> [ 6336.270758] mxl5007t_get_chip_id: MxL5007T detected @ 1-0060
> [ 6336.270772] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 03 1b 02 c0 00 00 00
> 04 00 20 fa
> [ 6336.273114] usb 1-2: dvb_usbv2_generic_rw: <<< 04 1b 04 e4 fb
> [ 6336.273126] usb 1-2: af9035_ctrl_msg: command=03 failed fw error=4
> [ 6336.273133] usb 1-2: af9035_ctrl_msg: failed=-5
> [ 6336.273139] mxl5007t_write_reg: 472: failed!
> [ 6336.273147] mxl5007t_attach: error -121 on line 903
> [ 6336.273164] usb 1-2: af9035_tuner_attach: failed=-19
> [ 6336.273172] usb 1-2: dvb_usbv2_adapter_frontend_init: tuner_attach()
> failed=-19
> [ 6336.273586] usb 1-2: dvb_usbv2_adapter_frontend_init: failed=-19
> [ 6336.273598] usb 1-2: dvb_usbv2_adapter_init: failed=-19
> [ 6336.273609] usb 1-2: dvb_usbv2_device_power_ctrl: power=0
> [ 6336.273619] usb 1-2: dvb_usbv2_init: failed=-19
> [ 6336.273629] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error while
> loading driver (-19)
> [ 6336.273665] usb 1-2: dvb_usbv2_disconnect: pid=2165 work_pid=2165
> [ 6336.273675] usb 1-2: dvb_usbv2_exit:
> [ 6336.273684] usb 1-2: dvb_usbv2_remote_exit:
> [ 6336.273693] usb 1-2: dvb_usbv2_adapter_exit:
> [ 6336.273703] usb 1-2: dvb_usbv2_adapter_frontend_exit: adap=0
> [ 6336.273713] usb 1-2: dvb_usbv2_adapter_dvb_exit: adap=0
> [ 6336.274470] usb 1-2: dvb_usbv2_adapter_stream_exit: adap=0
> [ 6336.274485] usb 1-2: usb_urb_free_urbs: free urb=5
> [ 6336.274497] usb 1-2: usb_urb_free_urbs: free urb=4
> [ 6336.274507] usb 1-2: usb_urb_free_urbs: free urb=3
> [ 6336.274518] usb 1-2: usb_urb_free_urbs: free urb=2
> [ 6336.274529] usb 1-2: usb_urb_free_urbs: free urb=1
> [ 6336.274540] usb 1-2: usb_urb_free_urbs: free urb=0
> [ 6336.274551] usb 1-2: usb_free_stream_buffers: free buf=5
> [ 6336.274569] usb 1-2: usb_free_stream_buffers: free buf=4
> [ 6336.274583] usb 1-2: usb_free_stream_buffers: free buf=3
> [ 6336.274597] usb 1-2: usb_free_stream_buffers: free buf=2
> [ 6336.274610] usb 1-2: usb_free_stream_buffers: free buf=1
> [ 6336.274622] usb 1-2: usb_free_stream_buffers: free buf=0
> [ 6336.274635] usb 1-2: dvb_usbv2_i2c_exit:
> [ 6336.274781] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' successfully
> deinitialized and disconnected
>
> with i2c changes:
> [ 6920.050685] i2c i2c-1: af9033: firmware version: LINK=11.5.9.0
> OFDM=5.17.9.1
> [ 6920.050695] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 80 01 0e 01 02 00 00 00
> 4c 01 23 fc
> [ 6920.051164] usb 1-2: dvb_usbv2_generic_rw: <<< 04 0e 00 f1 ff
> [ 6920.051181] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 80 01 0f 01 02 00 00 00
> 00 00 6e fd
> [ 6920.054803] usb 1-2: dvb_usbv2_generic_rw: <<< 04 0f 00 f0 ff
> [ 6920.054821] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9033
> (DVB-T))...
> [ 6920.055294] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 10 01 02 00 00 d8
> e0 01 0d 24
> [ 6920.055685] usb 1-2: dvb_usbv2_generic_rw: <<< 04 10 00 ef ff
> [ 6920.055701] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 11 01 02 00 00 d8
> e1 01 0b 24
> [ 6920.058686] usb 1-2: dvb_usbv2_generic_rw: <<< 04 11 00 ee ff
> [ 6920.058700] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 12 01 02 00 00 d8
> df 00 0c 25
> [ 6920.059057] usb 1-2: dvb_usbv2_generic_rw: <<< 04 12 00 ed ff
> [ 6920.090064] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 13 01 02 00 00 d8
> df 01 0b 24
> [ 6920.091043] usb 1-2: dvb_usbv2_generic_rw: <<< 04 13 00 ec ff
> [ 6920.392045] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 14 01 02 00 00 d8
> c0 01 29 24
> [ 6920.393057] usb 1-2: dvb_usbv2_generic_rw: <<< 04 14 00 eb ff
> [ 6920.393069] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 15 01 02 00 00 d8
> c1 01 27 24
> [ 6920.393424] usb 1-2: dvb_usbv2_generic_rw: <<< 04 15 00 ea ff
> [ 6920.393434] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 16 01 02 00 00 d8
> bf 00 28 25
> [ 6920.393789] usb 1-2: dvb_usbv2_generic_rw: <<< 04 16 00 e9 ff
> [ 6920.393798] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 17 01 02 00 00 d8
> b4 01 32 24
> [ 6920.394171] usb 1-2: dvb_usbv2_generic_rw: <<< 04 17 00 e8 ff
> [ 6920.394182] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 18 01 02 00 00 d8
> b5 01 30 24
> [ 6920.394539] usb 1-2: dvb_usbv2_generic_rw: <<< 04 18 00 e7 ff
> [ 6920.394549] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 01 19 01 02 00 00 d8
> b3 01 31 24
> [ 6920.394914] usb 1-2: dvb_usbv2_generic_rw: <<< 04 19 00 e6 ff
> [ 6920.412577] mxl5007t 1-0060: creating new instance
> [ 6920.412604] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 03 1a 02 c0 00 00 00
> fb d9 2a 21
> [ 6920.414075] usb 1-2: dvb_usbv2_generic_rw: <<< 04 1a 00 e5 ff
> [ 6920.414099] usb 1-2: dvb_usbv2_generic_rw: >>> 0a 00 02 1b 01 c0 00 00 00
> 24 fc
> [ 6920.414924] usb 1-2: dvb_usbv2_generic_rw: <<< 05 1b 00 14 d0 ff
> [ 6920.414935] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 1-0060
> [ 6920.414946] usb 1-2: dvb_usbv2_generic_rw: >>> 0c 00 03 1c 02 c0 00 00 00
> 04 00 1f fa
> [ 6920.417302] usb 1-2: dvb_usbv2_generic_rw: <<< 04 1c 04 e3 fb
> [ 6920.417312] usb 1-2: af9035_ctrl_msg: command=03 failed fw error=4
> [ 6920.417319] usb 1-2: af9035_ctrl_msg: failed=-5
> [ 6920.417325] mxl5007t_write_reg: 472: failed!
> [ 6920.417332] mxl5007t_attach: error -121 on line 940
> [ 6920.417351] usb 1-2: af9035_tuner_attach: failed=-19
> [ 6920.417358] usb 1-2: dvb_usbv2_adapter_frontend_init: tuner_attach()
> failed=-19
> [ 6920.417778] usb 1-2: dvb_usbv2_adapter_frontend_init: failed=-19
> [ 6920.417790] usb 1-2: dvb_usbv2_adapter_init: failed=-19
> [ 6920.417799] usb 1-2: dvb_usbv2_device_power_ctrl: power=0
> [ 6920.417809] usb 1-2: dvb_usbv2_init: failed=-19
> [ 6920.417819] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error while
> loading driver (-19)
> [ 6920.417853] usb 1-2: dvb_usbv2_disconnect: pid=11390 work_pid=11390
> [ 6920.417862] usb 1-2: dvb_usbv2_exit:
> [ 6920.417871] usb 1-2: dvb_usbv2_remote_exit:
> [ 6920.417881] usb 1-2: dvb_usbv2_adapter_exit:
> [ 6920.417890] usb 1-2: dvb_usbv2_adapter_frontend_exit: adap=0
> [ 6920.417899] usb 1-2: dvb_usbv2_adapter_dvb_exit: adap=0
> [ 6920.418769] usb 1-2: dvb_usbv2_adapter_stream_exit: adap=0
> [ 6920.418784] usb 1-2: usb_urb_free_urbs: free urb=5
> [ 6920.418796] usb 1-2: usb_urb_free_urbs: free urb=4
> [ 6920.418807] usb 1-2: usb_urb_free_urbs: free urb=3
> [ 6920.418818] usb 1-2: usb_urb_free_urbs: free urb=2
> [ 6920.418829] usb 1-2: usb_urb_free_urbs: free urb=1
> [ 6920.418840] usb 1-2: usb_urb_free_urbs: free urb=0
> [ 6920.418851] usb 1-2: usb_free_stream_buffers: free buf=5
> [ 6920.418868] usb 1-2: usb_free_stream_buffers: free buf=4
> [ 6920.418883] usb 1-2: usb_free_stream_buffers: free buf=3
> [ 6920.418896] usb 1-2: usb_free_stream_buffers: free buf=2
> [ 6920.418910] usb 1-2: usb_free_stream_buffers: free buf=1
> [ 6920.418924] usb 1-2: usb_free_stream_buffers: free buf=0
> [ 6920.418936] usb 1-2: dvb_usbv2_i2c_exit:
> [ 6920.419137] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' successfully
> deinitialized and disconnected
>
> Jose Alberto
>

AF9035 firmware returns error 4. Without the device I cannot do much. 
You have the stick, just try to tweak over it.


Antti

-- 
http://palosaari.fi/
